extends "res://active-partials/environment/door.gd"

func _on_door_mouse_enter():
	get_node("CollisionShape2D/icon").show()
	
func _on_door_mouse_exit():
	get_node("CollisionShape2D/icon").hide()
