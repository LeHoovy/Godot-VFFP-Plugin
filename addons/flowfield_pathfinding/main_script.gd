@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("PathingManager", "TileMap", preload("res://addons/flowfield_pathfinding/pathing_manager.gd"), preload("res://addons/flowfield_pathfinding/pathing_manager_icon.png"))#preload("pathing_node_icon.png"))

func _exit_tree():
	remove_custom_type("PathingManager")
