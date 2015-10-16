extends "res://active-partials/environment/door.gd"

func _init():
	new_stage_path = "res://active-partials/environment/FPO_stage_a.xml"
	new_stage = load(new_stage_path)

func _on_door_mouse_enter():
	get_node("CollisionShape2D/icon").show()
#pass # replace with function body


func _on_door_mouse_exit():
	get_node("CollisionShape2D/icon").hide()
	#pass # replace with function body
