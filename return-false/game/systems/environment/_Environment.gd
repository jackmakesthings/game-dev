extends Node2D

onready var Utils = get_node("/root/utils")
onready var nav = find_node("nav")
onready var tiles = find_node("ground")

signal walk_to(nav, end)

func _unhandled_input(ev):
	if Utils.is_click(ev):

		# This massive chunk of code cancels out the effects of the camera
		# on our positioning calculations
		var end = get_viewport_transform().affine_inverse().xform(ev.global_pos)
		
		# Flag used mostly for placement of the outline
		var adjust_path = false
		
		# Find the closest tile center to where we clicked
		var tilepos = tiles.world_to_map(end)
		var mappos = tiles.map_to_world(tilepos)
		end = mappos + Vector2(0, 16) 
		
		emit_signal("walk_to", nav, end)
		

func _ready():
	set_process_unhandled_input(true)
