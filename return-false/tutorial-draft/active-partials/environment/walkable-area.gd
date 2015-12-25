#####
# active-partials/environment/walkable-area.gd
# walkable stage, with floor tilemap and input handling for clicks
# TODO: should integrate with _ registry

extends Node2D

var TILE_ATTRACT = 8
var TILE_TRANSITION = 0

var scene
var player
var npcs
var utils

var body_layer
var nav
var tiles
var outline

var movement_allowed = true


#################
# tile_at(point)
# shortcut for checking which tile type is at (x,y)
func tile_at(point):
	var map_point = tiles.world_to_map(point)
	var tile_id = tiles.get_cell(map_point.x, map_point.y)
	return tile_id


#################
# set_tile_at(point, tile_id)
# the setter companion to that getter
func set_tile_at(point, tile_id):
	var _point = tiles.world_to_map(point)
	tiles.call("set_cell", _point.x, _point.y, tile_id)


#################
# get_surrounding_tiles(point)
# helper for checking all tiles adjacent to the one at a given point
# currently doesn't handle "corners" (N, E, S, W - iso map)
func get_surrounding_tiles(point):
	var map_pos = tiles.world_to_map(point)
	var NW = tiles.get_cell(map_pos.x-1, map_pos.y)
	var NE = tiles.get_cell(map_pos.x, map_pos.y-1)
	var SE = tiles.get_cell(map_pos.x+1, map_pos.y)
	var SW = tiles.get_cell(map_pos.x, map_pos.y+1)
	return Array([NW, NE, SE, SW])


#################
# check_for_attractor(Vector2: point)
# returns either a direction in which to orient the player, 
# or null if there's nothing "attractive" nearby
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


#################
# _unhandled_input(ev)
# this is where we process clicks into player pathfinding
# there's a lot going on here.
func _unhandled_input(ev):
	
	# only do something if it's a normal mouse click
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		
		# without this, running the scene standalone (while editing) fails
		# realistically, there should always be a player reference
		#if( player == null ) :
		#	return
		
		
		var begin = player.get_global_pos()
		
		# This massive chunk of code cancels out the effects of the camera
		# on our positioning calculations
		var end = get_viewport_transform().affine_inverse().xform( ev.global_pos )
		
		# Flag used mostly for placement of the outline
		var adjust_path = false
		
		# Find the closest tile center to where we clicked
		var tilepos = tiles.world_to_map(end)
		var mappos = tiles.map_to_world(tilepos)
		end = mappos + Vector2(0, 16) 
		
		# Store which type of tile is at that point
		var tile_at = tiles.get_cell(tilepos.x, tilepos.y)
		
		# if the player clicked an un-walkable tile,
		# we'll remove the end point from the calculated path
		# so the targeting outline shows where it will really end up
		if ( tiles.get_tileset().tile_get_navigation_polygon(tile_at) == null ):
			adjust_path = true
			

		
		if( movement_allowed ):
			print("moving node ", player.get_name(), " from ", begin, " to ", end, " in ", nav.get_name())
			player.update_path(begin, end, nav);
			outline.show()
			
			# move the outline and remove the unwalkable point, if needed
			if( adjust_path ):
				outline.set_global_pos(player.path[1])
				player.path[0] = player.path[1]
			else:
				outline.set_global_pos(end)
			
			# ev.meta can be set to prevent an outline from appearing
			if( ev.meta == 1 ):
				outline.hide()
		
			yield(player, "done_moving")
			outline.hide()
			get_surrounding_tiles(player.get_global_pos())
			
			# are we standing next to someone we should turn and face?
			var orient = check_for_attractor(player.get_global_pos())
			if( orient != null ):
				player.orient(orient)



#################
# set_internals()
# setup func for things that don't depend on nodes outside of this tree
# can always be safely hooked into _ready, in theory
func set_internals():
	
	# vars
	nav = get_node("nav")
	tiles = get_node("nav/floor")
	body_layer = get_node("nav/floor/bodies")
	player = find_node("robot")
	npcs = get_tree().get_nodes_in_group("npcs")
	outline = get_node("destination_sprite")
	TILE_ATTRACT = tiles.get_tileset().find_tile_by_name("attractor")
	
	#actions
	# hide the green destination indicator, to start
	outline.hide()
	
	# and hook up the npcs so they can create attractor tiles
	for i in npcs:
		if is_a_parent_of(i):
			i.set_owner(self)
			i.set_paths()
			i.set_attractors()



#################
# set_externals()
# separate setup func for things that are outside of this tree
# (which may need to be handled via a different signal/callback)

func set_externals():
	
	# if we aren't in the tree, don't even bother
	if( !is_inside_tree() ):
		scene = null
		player = null
		return
		
	# vars
	# 1) stage nodes will always be children of the main scene
	scene = get_parent()
	player = find_node("robot")
	
	# 2) player --- TODO: should this use scene.player or _.player?
#	if( scene.get("player") != null ):
#		player = scene.get("player")
#	else:
#		player = null



#################
func _ready():
	
	# Setup the vars and conditions for this instance
	
	set_internals()
	set_externals()
	
	# start listening for clicks (for moving the player)
	set_process_unhandled_input(true)

func _enter_tree():
#	set_name("stage")
	set_internals()
	set_externals()