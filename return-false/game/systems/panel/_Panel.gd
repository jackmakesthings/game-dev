# Panel base node
# Texture on this node = area background.
# Player and other scene objects should be
# instanced/added as children of the YSort.

# @TODO - look into extracting the "Navigation2D"
# or refactoring how nav polys are used - 
# maybe overwrite instead of replace when changing scenes?

extends Node2D

onready var object_layer = find_node('YSort')
onready var nav = find_node('Navigation2D')
signal walk_to

func _ready():
	set_process_unhandled_input(true)
	
func _unhandled_input(ev):
	if Utils.is_click(ev):
		var evpos = get_viewport_transform().affine_inverse().xform(ev.global_pos)
		emit_signal('walk_to', evpos, nav)