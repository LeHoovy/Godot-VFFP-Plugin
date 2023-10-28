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


var chunk_grid_clearance: Dictionary
var chunk_grid_values: Dictionary


func _enter_tree():
	#pressed.connect(clicked)
	pass


func _ready():
	var applicable_tiles: Array[Vector2i]
	
	if whitelist:
		list.pop_at(list.find(Vector2i(-1, -1)))
	
	get_tiles()
	print()
	print(vector2_range(Vector2i(3, 2), Vector2i(0, 0), Vector2i(-1, -1)))
	print(range(3, 0, -1))


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
		while current_iteration.y < b.y:
			while current_iteration.x < b.x:
				output.append(current_iteration)
				current_iteration.x += 1
			current_iteration = Vector2i(0, current_iteration.y + 1)
		return output
	
	current_iteration = b
	while current_iteration.y != n.y:
		while current_iteration.x != n.x:
			output.append(current_iteration)
			current_iteration.x += step.x
			#output.append(current_iteration)
		current_iteration = Vector2i(b.x, current_iteration.y + step.y)
	return output


func get_tiles():
	print(Vector2(get_used_rect().size) / 5)
	for chunk in vector2_range(Vector2(get_used_rect().size / 5).ceil()):
	#for chunk in vector2_range(Vector2i(ceili(float(get_used_rect().size.x) / 5), ceili(float(get_used_rect().size.y) / 5))):
		print(chunk)
	#for chunk_x in range(ceili(float(get_used_rect().size.x) / 5)):
		#for chunk_y in range(ceili(float(get_used_rect().size.y) / 5)):
			##print("(", chunk_x, ",", chunk_y, ")")
			#pass



