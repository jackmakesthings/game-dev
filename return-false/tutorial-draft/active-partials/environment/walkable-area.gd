#####
# walkable stage, with floor tilemap and input handling for clicks

extends Node2D

var player
var nav
var tiles
var outline
var movement_allowed = true

func _unhandled_input(ev):

	# Move character around on click
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		
		var begin = player.get_global_pos()
		
		# This massive chunk of code cancels out the effects of the camera
		# on our positioning calculations
		var end = get_viewport_transform().affine_inverse().xform( ev.global_pos )
		
		# Flag used mostly for placement of the outline
		var adjust_path = false
		
		# Find the closest tile center to where we clicked
		var tilepos = tiles.world_to_map(end)
		var mappos = tiles.map_to_world(tilepos)
		end = mappos + Vector2(0, 18) 
		
		# Store which type of tile is at that point
		var tile_at = tiles.get_cell(tilepos.x, tilepos.y)
		
		# if the player clicked an un-walkable tile,
		# we'll remove the end point from the calculated path
		# so the targeting outline shows where it will really end up
		if ( tiles.get_tileset().tile_get_navigation_polygon(tile_at) == null ):
			adjust_path = true
		
		
		
		if( movement_allowed ):
			player.update_path(begin, end, nav);
			outline.show()
			
			if( adjust_path ):
				outline.set_global_pos(player.path[1])
				player.path[0] = player.path[1]
			else:
				outline.set_global_pos(end)
				
			yield(player, "done_moving")
			outline.hide()
	
func _ready():
	# Setup the vars and conditions for this instance
	
	#Input.set_mouse_mode(0)
	player = get_node("/root/scene/robot")
	nav = get_node("nav")
	tiles = get_node("nav/floor")
	outline = get_node("Polygon2D")
	
	
	# reparent the player character to this tile instance
	# note - if we're using the player path anywhere else,
	# it should probably be updated here and stored globally
	
	get_node("/root/scene").remove_child(player)
	nav.get_node("floor").add_child(player)
	
	outline.hide()
	set_process_unhandled_input(true)
