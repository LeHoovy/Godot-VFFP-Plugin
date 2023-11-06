extends Node
class_name PathingLayer


var heat_map: Dictionary


func _ready():
	if not get_parent() is TileMap and not get_parent() is PathingManager:
		print("Pathing layer added as a child to that which can not have pathing layers")
		queue_free()
