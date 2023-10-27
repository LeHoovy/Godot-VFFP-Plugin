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

@export_category("Whitelisted or blacklisted tiles")
##True means tiles on the list are whitelisted, vice versa for false. If blacklisted, tiles in the list will not be considered in heatmap generation.
@export var whitelist_blacklist: bool = false
##Add tiles here to be whitelisted or blacklisted. If whitelisted, empty tiles (the -1, -1 coord) will be removed. This is in TileMap/Tileset Atlas coords. 
@export var list: Array[Vector2i] = [Vector2i(-1, -1)]


func _enter_tree():
	#pressed.connect(clicked)
	pass


func _ready():
	var applicable_tiles: Array[Vector2i]
	
	if whitelist_blacklist:
		list.pop_at(list.find(Vector2i(-1, -1)))


func get_tiles():
	
	for chunk: Vector2i in Vector2i(ceili(get_used_rect().size.x / 5), ceili(get_used_rect().size.y / 5)):
			pass



