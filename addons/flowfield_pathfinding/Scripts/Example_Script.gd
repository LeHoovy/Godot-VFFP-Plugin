extends Node2D


func _ready():
	var test: Node = PathingLayer.new()
	add_child(test)


func _process(delta):
	if Input.is_action_just_pressed("RMB"):
		$PathingManager.pathfind($PathingManager.local_to_map($PathingManager.get_local_mouse_position()))
	
	if Input.is_action_just_pressed("LMB"):
		$PathingManager.read_heat($PathingManager.local_to_map($PathingManager.get_local_mouse_position()), 0)
	
	if Input.is_action_just_pressed("Spacebar"):
		print($PathingManager.get_children())
