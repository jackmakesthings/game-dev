
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var go_right
var ground
var lbl

func _ready():
	ground = get_node("ground")
	lbl = get_node("view_control/Label")
	#set_fixed_process(true)
	# Initialization here
	pass

func _fixed_process(delta):
	lbl.set_text(str(100&delta))
	#if( go_right == true ):
		#var now = ground.get_offset().x + 1000*delta
		#.translated(Vector2(100, 0))
	#	set_global_transform(
		#print(ground.get_offset().x, " vs ", now)
		#set_global_transform(now)
		#get_node("ground").set_offset(Vector2(100*delta, 0))


#func _on_right_input_event( ev ):
#	if( ev.type == InputEvent.MOUSE_MOTION ):
#	go_right = true
#		set_fixed_process(true)
	

#	pass # replace with function body


func _on_right_mouse_exit():
	#go_right = false
	set_fixed_process(false)
	pass # replace with function body


func _on_right_mouse_enter():
	go_right = true
	set_fixed_process(true)
	#pass # replace with function body
