@tool
extends TileMap
class_name PathingManager
##short desc
##
##long desc
##long desc continued
##
##tutorials here

#var size : Vector2i = get_used_rect().size
#var startY : int = get_used_rect().position.y
#var startX : int = get_used_rect().position.x
#var width : float = size.x
#var height : float = size.y

@export_category("||DEBUG||")
@export var vectors: bool = false

@export_category("Whitelisted or blacklisted tiles")
##True means tiles on the list are whitelisted, vice versa for false. If blacklisted, tiles in the list will not be considered in heatmap generation.
@export var whitelist: bool = false
##Add tiles here to be whitelisted or blacklisted. If whitelisted, empty tiles (the -1, -1 coord) will be removed. This is in TileMap/Tileset Atlas coords. 
@export var list: Array[Vector2i] = [Vector2i(-1, -1)]


func layer_up():
	pass


func layer_down():
	pass


func _enter_tree():
	#pressed.connect(clicked)
	pass

signal debug_upate
@onready var debug_ui = get_parent().get_node("Camera").get_node("Container")
func debug_update(toggled: String):
	if toggled == "Vectors":
		if toggled:
			
			
			debug_upate.emit()
		
	if toggled == "Debug UI":
		debug_ui.get_node("Up").visible = !debug_ui.get_node("Up").visible
		debug_ui.get_node("Down").visible = !debug_ui.get_node("Down").visible
		get_node("DebugVectorContainer").visible = !get_node("DebugVectorContainer").visible


func getAllSurroundingCells(cell):
	var allNeighbors : Array[Vector2i] = [
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_RIGHT_SIDE), #0
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER), #45
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), #90
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER), #135
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_LEFT_SIDE), #180
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER), #225
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_SIDE), #270
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)]#315
	return allNeighbors


func _ready():
	var applicable_tiles: Array[Vector2i]
	
	if whitelist:
		list.pop_at(list.find(Vector2i(-1, -1)))
	
	get_tiles()
	#print()
	#print(vector2_range(Vector2i(3, 2), Vector2i(0, 0), Vector2i(-1, -1)))
	#print(range(3, 0, -1))


func vector2_range(b: Vector2i, n: Variant = null, step: Vector2i = Vector2i(1, 1)) -> Array[Vector2i]:
	if n != null:
		if not n is Vector2i:
			push_error('Can not take ', typeof(n), ' as an input. Replace ', n, ' with a Vector2i() or Vector2i variable.')
	#Makes certain output and current_iteration are empty
	var output: Array[Vector2i] = []
	var current_iteration: Vector2i = Vector2i(0, 0)
	
	#If N is not selected, start from (0, 0) and go to B. Otherwise, go from B to N.
	if n == null:
	#Adds step to the vector.x after adding the current iteration to the output array, loops back to 0 after reaching the n, and adds step to vector.y
		while current_iteration.x < b.x:
			while current_iteration.y < b.y:
				output.append(current_iteration)
				current_iteration.y += 1
			current_iteration = Vector2i(current_iteration.x + 1, 0)
		return output
	
	current_iteration = b
	while current_iteration.x != n.x:
		while current_iteration.y != n.y:
			output.append(current_iteration)
			current_iteration.y += step.y
			#output.append(current_iteration)
		current_iteration = Vector2i(step.x + current_iteration.x, b.y)
	return output


func get_tile_whitelist(tile: Vector2i, layer: int = 0):
	if list.has(get_cell_atlas_coords(layer, tile)):
		return true
	else:
		return false


var tiles_per_chunk: int = 5
var chunks: Array
var chunk_grid_clearance: Dictionary
var chunk_tiles: Dictionary
#var chunk_grid_values: Dictionary
func get_tiles():
	#print(Vector2(get_used_rect().size) / tiles_per_chunk)
	for chunk in vector2_range(Vector2(get_used_rect().size / tiles_per_chunk).ceil()):
		#print(chunk)
		chunks.append(chunk)
		scan_chunk(chunk)
		#print(chunk, " : ", chunk_tiles.get(chunk))


func scan_chunk(chunk_pos):
	chunk_tiles[chunk_pos] = []
	for tile in vector2_range(Vector2i(0, 0), Vector2i(tiles_per_chunk, tiles_per_chunk)):
		tile += chunk_pos * tiles_per_chunk
		#print(tile)
		chunk_tiles[chunk_pos].append(tile)# + (chunk_pos * tiles_per_chunk))


func pathfind(target):
	var id: int = 0
	var new_layer: Node = PathingLayer.new()
	#var layer_heat_map: Dictionary = generate_heatmap(target)
	#print(layer_heat_map)
	
	if get_children():
		for child in get_children():
			if child.name != str("Layer", id):
				new_layer.name = str("Layer", id)
				break
			id += 1
			new_layer.name = str("Layer", id)
	else:
		new_layer.name = "Layer0"
		
	add_child(new_layer)
	new_layer.heat_map = generate_heatmap(target)


func read_heat(tile: Vector2i, layer: int = 0) -> void:
	if get_children():
		print('children!')
	print(!get_tile_whitelist(tile, layer))
	if get_children() and !get_tile_whitelist(tile, layer):
		print(get_node(str("Layer", layer)).heat_map.get(tile))


func generate_heatmap(target: Vector2i, applicable: Array = []) -> Dictionary:
	var open: Array[Vector2i] = [target] #Self explanatory
	#Each key should be a Vector2i, each value should be a heat value
	var heat_map: Dictionary = {target: 0}#Typed dictionaries when? Also makes sure that theres something in the list
	
	var selected: Vector2i
	#print(open, heat_map)
	#TEMPORARY CODE, REPLACE WHEN HPA* DONE
	for tile in vector2_range(get_used_rect().size):
		if get_tile_whitelist(tile, 0):
			continue
		applicable.append(tile)
	#print(applicable)
	#If there are tiles to be processed, continue
	while open.size() > 0:
		selected = open[0] #(The selected tile is the oldest in the list)
		for current in getAllSurroundingCells(selected):
			if !applicable.has(current):
				continue #If it won't pathfind, don't let it have a heat value
			elif heat_map.has(current):
				if heat_map.get(current) > heat_map.get(selected) + 1:
					heat_map[current] = heat_map.get(selected) + 1
					if !open.has(current):
						open.append(current)
					continue #If it can pathfind, and has a heat value, if its high, make it lower
				else:
					continue #Can't do anything though? Just continue!
			else:
				if !open.has(current):
					open.append(current) #Only add the current node to open if its not already in it
				heat_map[current] = heat_map.get(selected) + 1 #And here we increase the heat for empty values.
		open.pop_front() #Clear the current run.
		#print("Loop completed, relooping")
	return heat_map #yeah
