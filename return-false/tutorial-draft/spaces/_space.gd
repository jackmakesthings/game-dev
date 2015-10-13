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
var utils = preload("res://scripts/utils.gd").new()

const TILE_ATTRACT = 7
const TILE_TRANSITION = 0

# shortcut for checking which tile type is at (x,y)
func tile_at(point):
	var map_point = tiles.world_to_map(point)
	var tile_id = tiles.get_cell(map_point.x, map_point.y)
	return tile_id
	

# shortcut for getting the "tile position" at a point
func cell_at(point):
	return tiles.world_to_map(point)

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
			
			# this is going to be properly implemented soon
			#var transitioning = check_for_transition(player.get_global_pos())
			#if( transitioning == true ):
			#	_test_tile_logic()
			#	utils.goto_scene("res://main.xml", {})


func change_tiles(new_tilemap):
	tiles.hide()
	tiles.remove_child(body_layer)
	var new_tile_node = nav.get_node(new_tilemap)
	nav.move_child(new_tile_node, 0)
	tiles = nav.get_child(0)
	tiles.add_child(body_layer)
	body_layer = tiles.get_child(0)
	tiles.show()
	#for i in range(-20, 20):
	#	tiles.set_cell(10+i, i, 5, false, false, false)
	#	tiles.set_cell(i, 10, 5, false, false, false)
		#tiles.set_cell(i, 10, 5, false, false, false)
	
	
func _test_tile_logic():
	if( tiles.get_name() == "floor" ):
		change_tiles("floor_2")
	elif( tiles.get_name() == "floor_2"):
		change_tiles("floor_3")
	else:
		change_tiles("floor")


func _ready():
	# Setup the vars and conditions for this instance
	#if( get_node("/root/scene") ):
	#	scene = get_node("/root/scene")
	#	if( scene != null ):
	#		player = scene.get("player")
	
	if ( get_node("nav/floor/bodies/robot") ):
		player = get_node("nav/floor/bodies/robot")
	
	
	
	
#	body_layer = get_node("nav/floor/bodies")
	nav = get_node("nav")
	tiles = get_node("nav").get_child(0)
	body_layer = tiles.get_node("bodies")
	outline = get_node("destination_sprite")
	utils = get_node("/root/utils")
	
	outline.hide()
	if( player != null ):
		set_process_unhandled_input(true)
