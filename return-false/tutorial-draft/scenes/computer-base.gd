
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_fixed_process(true)
	# Initialization here
	pass


func _fixed_process(delta):
	if( is_colliding() ):
		print("!!!")

func _on_computer_body_enter( body ):
	print(body)
	pass # replace with function body


func _on_computer_area_enter( area ):
	print(area)
	pass # replace with function body


func _on_computer_body_enter_shape( body_id, body, body_shape, area_shape ):
	print(body_id)
	print(body)
	pass # replace with function body
