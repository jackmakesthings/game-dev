#####
# walkable stage, with floor tilemap and input handling for clicks

extends Node2D

var scene
var player

var body_layer
var nav
var tiles
var outline
var movement_allowed = true
var utils

const TILE_ATTRACT = 7
const TILE_TRANSITION = 0

# shortcut for checking which tile type is at (x,y)
func tile_at(point):
	var map_point = tiles.world_to_map(point)
	var tile_id = tiles.get_cell(map_point.x, map_point.y)
	return tile_id

# helper for checking all tiles adjacent to the one at a given point
func get_surrounding_tiles(point):
	var map_pos = tiles.world_to_map(point)
	var NW = tiles.get_cell(map_pos.x-1, map_pos.y)
	var NE = tiles.get_cell(map_pos.x, map_pos.y-1)
	var SE = tiles.get_cell(map_pos.x+1, map_pos.y)
	var SW = tiles.get_cell(map_pos.x, map_pos.y+1)
	return Array([NW, NE, SE, SW])

func check_for_attractor(point):
	var borders = get_surrounding_tiles(point)
	if( borders[0] == TILE_ATTRACT ):
		return "NW"
	elif( borders[1] == TILE_ATTRACT ):
		return "NE"
	elif( borders[2] == TILE_ATTRACT ):
		return "SE"
	elif( borders[3] == TILE_ATTRACT ):
		return "SW"
	else:
		return null
		

func check_for_transition(point):
	return ( tile_at(point) == TILE_TRANSITION )

func _unhandled_input(ev):

	# Move character around on click
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		
		if( player == null ) :
			return
		
		
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
				
			if( ev.meta == 1 ):
				outline.hide()
		
			yield(player, "done_moving")
			outline.hide()
			get_surrounding_tiles(player.get_global_pos())
			
			var orient = check_for_attractor(player.get_global_pos())
			if( not orient == null ):
				player.orient(orient)
			


func _enter_tree():
	scene = get_parent()
	if( scene.get("player") != null ):
		player = scene.get("player")	
			
func _ready():
	# Setup the vars and conditions for this instance
	scene = get_parent()
	if( scene.get("player") != null ):
		player = scene.get("player")
	else:
		player = null
	
	nav = get_node("nav")
	tiles = get_node("nav/floor")
	body_layer = get_node("nav/floor/bodies")
	outline = get_node("destination_sprite")
	utils = get_node("/root/utils")
	
	outline.hide()
	set_process_unhandled_input(true)
	
