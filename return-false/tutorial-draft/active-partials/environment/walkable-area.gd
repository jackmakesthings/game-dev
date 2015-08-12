#####
# walkable stage, with floor tilemap and input handling for clicks

extends Node2D

var player
var nav
var movement_allowed = true

func _unhandled_input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		
		var begin = player.get_global_pos()
		var end = ev.global_pos
		
		#begin = get_viewport_transform().affine_inverse().xform( begin )
		end = get_viewport_transform().affine_inverse().xform( end )
		
		if( movement_allowed ):
			player.update_path(begin, end, nav);
		
	
func _ready():
	Input.set_mouse_mode(0)
	player = get_node("/root/scene/robot")
	nav = get_node("nav")
	get_node("/root/scene").remove_child(player)
	nav.get_node("floor").add_child(player)
	set_process_unhandled_input(true)