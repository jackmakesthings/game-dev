extends KinematicBody2D

var last_pos = Vector2()
var begin = Vector2()
var end = Vector2()
var destination = Vector2()
var path = []
var is_moving = false

const SPEED = 150.0

signal done_moving(from, to, path)

# update_path(nav, end)
# takes a navigation2d node and a destination
func update_path(nav, end):

	last_pos = get_pos()
	begin = last_pos

	var p = nav.get_simple_path(begin, end, false)
	path = Array(p)
	path.invert()
	set_fixed_process(true)


func walk(delta):

	if path.size() > 1:
		var to_walk = delta * SPEED

		while to_walk > 0 and path.size() >= 2:
			is_moving = true

			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			var d = pfrom.distance_to(pto)

			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk = to_walk - d

			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk = 0

		var next_pos = path[path.size() - 1]
		move_to(next_pos)

		if is_colliding():
			var n = get_collision_normal()
			var motion = n.slide(next_pos - get_global_pos())
			move(motion)

		#reaching our destination
		if path.size() < 2:
			halt()

	else:
		halt()


func halt():
	set_fixed_process(false)
	path.clear()
	#set_fixed_process(true)


func _fixed_process(delta):
	walk(delta);


func _ready():
	is_moving = false
	set_fixed_process(false)
