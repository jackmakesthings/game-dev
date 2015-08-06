extends Node2D

var player
var quest
var nav
var message_ui

var gamedata
var savefile = "user://gamedata"

func _input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		
		var begin = player.get_global_pos()
		var end = ev.global_pos
		
		if( message_ui.move_player ):
			player.update_path(begin, end);
			#yield(player, "done_moving")

			
		#if( message_ui.is_active and message_ui.response_array.size() < 1 ):
		#	message_ui.close()
		#	message_ui.enable_interactions()
			
	elif( ev.type == InputEvent.KEY and ev.pressed ):
		var key_choice = OS.get_scancode_string(ev.scancode)
		message_ui.choose_response_by_key(key_choice)

func _ready():
	var paths = get_node("/root/paths")
	
	player = get_node(paths.player)
	quest  = get_node(paths.quest)
	nav = get_node(paths.nav)
	message_ui = get_node(paths.message_ui)
	
	player.set_name("Trace")
	set_process_input(true)