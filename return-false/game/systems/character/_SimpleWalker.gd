# Base walking type, used by the Player subscene
# Handles responses to "walk here" signals from the Environment
# and includes methods for turning to face the right way
# (which should theoretically work on square tilemaps too)
extends KinematicBody2D


# Member Vars

# speed  : Float; pixels/delta movement rate
# last_pos : Vector2; the node's latest position
# path     : Array; walk points generated by a Navigation2D
# is_moving: Boolean; whether the player is mid-walk
# conversation_queued: Boolean; whether the player is on their way to talk to an NPC
# anim_node: Node; descendant AnimationPlayer for sprite
# ref_node: Node; descendant CollisionShape used as a position reference

export(int) var speed
var last_pos = Vector2()
var path = []
var nav
var is_moving = false
var conversation_queued = false
onready var anim_node = find_node("AnimationPlayer")
onready var ref_node = find_node("CollisionShape2D")
onready var camera = find_node('Camera2D')


# Signals

##
# path_updated(path)
# Emitted on path updates/walk initiation
# Can be connected to the matching method on Environment
# to trigger hiding/showing the destination marker.
# @path : Array; the current walk path
##
signal path_updated(path)

##
# done_moving(from, to)
# Emitted when the destination is reached.
# @from : Vector2; the previous starting point
# @to   : Vector2; the final destination
##
signal done_moving(from, to)

##
# done_orienting
# Emmited after a player walks to an NPC and turns towards them;
# the NPC will wait for this signal before starting conversation.
##
signal done_orienting


# Methods


func _fixed_process(delta):
	walk(delta);

func _ready():
	is_moving = false
	set_fixed_process(false)

##
# update_path(nav, end, adjust_path, tiles)
# Triggered by the Environment.walk_to signal, on click
# Tells the player to start walking somewhere.
#
# @nav : Node; Navigation2D instance
# @end : Vector2; clicked destination point
##
func update_path(end, nav=self.nav):
	if nav and not self.nav:
		self.nav = nav
	# Store the current position
	last_pos = get_global_pos()

	# Get our walk path from the Navigation2D
	var p = nav.get_simple_path(last_pos, end, false)
	path = Array(p)
	path.invert()

	# Start moving
	set_fixed_process(true)
	emit_signal("path_updated", path)


##
# walk(delta)
# Attached to the _fixed_process callback; moves the player
# by a consistent amount over time, updating .path as it goes
#
# @delta : Float; time since last call
##
func walk(delta):

	# If we're already there, forget it
	if path.size() <= 1:
		halt()
		return

	else:
		# Calculate how far to move this time
		var to_walk = delta * speed

		while to_walk > 0 and path.size() >= 2:
			is_moving = true

			# Get the current path segment, and the direction of travel
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			var d = pfrom.distance_to(pto)

			# If it's a short trip, go all the way
			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk = to_walk - d

			# If not, interpolate some steps to get there
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk = 0


		var next_pos = path[path.size() - 1]

		# Turn towards the next path point, then walk there
#		orient(Utils.get_orient(dir))
		orient(Utils.get_orient_between(get_global_pos(), next_pos))
		move_to(next_pos)

		# Handle collisions - note, not currently tested, needs work
		if is_colliding():
			var n = get_collision_normal()
			var motion = n.slide(next_pos - get_global_pos())
			move(motion)

		# If we're reaching our destination:
		if path.size() < 2:
			halt()

##
# halt()
# Stops the walk process and animation, and resets the path
# Call this to bring the player to a 'complete stop'.
##
func halt():
	is_moving = false
	emit_signal("done_moving", last_pos, get_pos())
	set_fixed_process(false)
	anim_node.seek(0.0, true)
	anim_node.stop()
	path.clear()


##
# get_footprint()
# Returns the position of ref_node for more accurate position/direction calculations
##
func get_footprint():
	return ref_node.get_global_pos()


##
# orient(NESW)
# Called when starting to walk a new path segment;
# sets the player animation to the right direction
#
# @NESW : String; the compass direction/animation name to set
func orient(NESW):
	if anim_node.get_current_animation() != NESW:
		anim_node.play(NESW)
	if anim_node.get_current_animation() == NESW and !anim_node.is_playing():
		anim_node.play(NESW)


##
# orient_towards(vector)
# Similar to orient(), but for use when the player is done moving
# and needs to make sure it's facing the NPC/object it walked to
#
# @vector : Vector2; direction from self to the object of interest
func orient_towards(vector):
	var NESW = Utils.get_orient_between(get_footprint(), vector)
	anim_node.play(NESW)
	anim_node.seek(0.0, true)	
	anim_node.stop()
	emit_signal("done_orienting")
	
	
