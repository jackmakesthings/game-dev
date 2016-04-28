extends Node2D

onready var nav = find_node("nav")
onready var tiles = find_node("ground")
onready var marker = find_node("marker")


signal walk_to(nav, end, adjust)

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
		var tilesize = tiles.get_cell_size()
		end = mappos + Vector2(0, tilesize.y/2) 

		# See what kind of tile we're trying to walk to
		# If it's unwalkable, the actor will go to the next closest point on the way.
		var tile_at = tiles.get_cell(tilepos.x, tilepos.y)
		if tiles.get_tileset().tile_get_navigation_polygon(tile_at) == null:
			adjust_path = true

		emit_signal("walk_to", nav, end, adjust_path, tiles)
		


func on_path_updated(path):
	var endpoint = path[0]
	marker.set_pos(endpoint)
	marker.set('visibility/visible', true)

func on_motion_end(from, to):
	marker.set('visibility/visible', false)	


func _ready():
	set_process_unhandled_input(true)
