# Base environment type
# This gets instanced as .Scene by the game root
# and contains one "level" - tilemaps and entities for an area.
# Its main responsibility is enabling player movement.
extends Node2D


# Member Vars

# nav    : Node: this scene's Navigation2D instance
# tiles  : Node; this scene's walkable TileMap
# marker : Node; the "destination" indicator sprite
# objects: Node; the YSorted TileMap which holds entities

onready var nav = find_node("nav")
onready var tiles = find_node("ground")
onready var marker = find_node("marker")
onready var object_layer = find_node("objects")


# Signals

##
# walk_to(nav, end, adjust)
# Emitted when a player destination is set (via click)
#
# @nav   : NodePath; the Navigation2D instance to use for pathfinding
# @end   : Vector2; the destination point
# @adjust: Boolean; true if 'end' is not a valid walkable point
##
signal walk_to(nav, end, adjust)


# Methods


##
# _ready
# Enables input handling so clicks will be processed
##
func _ready():
	set_process_unhandled_input(true)


##
# _unhandled_input(ev)
# Translates an input event (if it's a click) into a walk command.
#
# @ev : Input event
##
func _unhandled_input(ev):
	if Utils.is_click(ev):

		# This chunk of code cancels out the effects of the camera
		# on our positioning calculations
		var end = get_viewport_transform().affine_inverse().xform(ev.global_pos)
		
		# Flag used mostly for placement of the outline
		var adjust_path = false
		
		# Find the closest tile center to where we clicked
		var tilepos = tiles.world_to_map(end)
		var mappos = tiles.map_to_world(tilepos)
		var tilesize = tiles.get_cell_size()
		end = mappos + Vector2(0, tilesize.y/2) 

		# See what kind of tile we're trying to walk to
		# If it's unwalkable, the actor will go to the next closest point on the way.
		var tile_at = tiles.get_cell(tilepos.x, tilepos.y)
		if !tiles.get_tileset().tile_get_navigation_polygon(tile_at):
			adjust_path = true

		emit_signal("walk_to", nav, end, adjust_path, tiles)
		

##
# on_path_updated(path)
# If connected to the matching signal on Player,
# this displays a destination marker to show where the Player will stop.
#
# @path : Array; Player's current path
##
func on_path_updated(path):
	var endpoint = path[0]
	marker.set_pos(endpoint)
	marker.set('visibility/visible', true)


##
# on_motion_end(from, to)
# The counterpart to on_path_updated, this can be triggered
# once the player arrives at their destination.
# NOTE: The params come from the signal, but aren't used here.
#
# @from : Vector2; Player's starting point
# @to   : Vector2; Player's ending point
##
func on_motion_end(from, to):
	marker.set('visibility/visible', false)	
