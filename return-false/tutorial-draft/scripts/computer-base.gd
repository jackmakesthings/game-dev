
extends Node2D

# member variables here, example:
# var a=2z
# var b="textvar"

export var message="blip"

func _ready():
	set_process_input(true)
	# Initialization here
	#pass

func _input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		print(message)
		#var begin = player.get_pos()
		#var end = ev.pos
		#print(begin,end)
		
		#player.set_pos(end)
		## - get_pos()    # convert our endpoint to be relative from start point
		#player.update_path(begin, end)
	pass
	
func _on_computer_body_enter( body ):
	print("hey kid")
	print("im a computer")
	print("stop all the downloadin")
	get_node("Label").set_text("Message: " + message + "")
	pass # replace with function body
