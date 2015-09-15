
extends Button

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	#get_node("Label").set_opacity(0)
	get_node("Label").set_text("•-")
	# Initialization here


func mouse_exit():
	#get_node("Label").set_opacity(0.0)
	get_node("Label").set_text("-")


func mouse_enter():
	#get_node("Label").set_opacity(1.0)
	get_node("Label").set_text(">")