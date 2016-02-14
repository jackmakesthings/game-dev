### standard walking kinematic character
### needs to be passed a reference to the Nav2D node
### walks to point of click


extends KinematicBody2D

var begin=Vector2()
var end=Vector2()
var path=[]
var destination
var is_moving

var spr
var nav
export(Texture) var front_texture
export(Texture) var back_texture

var last_pos
var anim
var general_direction

#const SPEED=150.0
const SPEED = 40.0

var frames = {
	S = 0,
	SW = 9,
	W = 18,
	NW = 27,
	N = 36,
	NE = 45,
	E = 54,
	SE = 63
}

signal start_moving(from, to, path)
signal done_moving(at)
signal oriented(dir, at)

# TODO: make sure this can be safely removed
func orient():
	pass


func _rotate_to(dir):

	var new_anim

	if( -25 <= dir and dir < 25 ):
		new_anim = "N"
	elif( 25 <= dir and dir < 65 ):
		new_anim = "NW"
	elif( 65 <= dir and dir < 116 ):
		new_anim = "W"
	elif( 116 <= dir and dir < 155 ):
		new_anim = "SW"
	elif(( 155 <= dir and dir <= 180 ) or ( -180 <= dir and dir <= -155 )):
		new_anim = "S"
	elif( -65 <= dir and dir < -25 ):
		new_anim = "NE"
	elif( -116 <= dir and dir < -65 ):
		new_anim = "E"
	elif( -155 <= dir and dir < -116 ):
		new_anim = "SE"
	else:
		new_anim = "S"
	
	return new_anim

	

func halt():
	set_fixed_process(false)
	path.clear()
	set_fixed_process(true)



func _fixed_process(delta):

	last_pos = get_global_pos()

	if (path.size()>1):
	
		var to_walk = delta*SPEED
		
		while(to_walk>0 and path.size()>=2):
			is_moving = true
		
			# prepare path segments
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			var d = pfrom.distance_to(pto)
			
			# turn trace towards his destination
			var direction = ( pto - pfrom).normalized()
			
			#align_sprite(spr, direction)
			if (d<=to_walk):
				path.remove(path.size()-1)
				to_walk-=d
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk=0
				
		var atpos = path[path.size()-1]
		var direction = _rotate_to(rad2deg(get_pos().angle_to_point(atpos)))
		
		if( direction != anim.get_current_animation() ):
			anim.play(direction)
		move_to(atpos);
		
		# handle collisions
		if(is_colliding()):
			var n = get_collision_normal()
			var motion = n.slide(atpos - get_global_pos())
			move(motion)
			
		# reaching our destination
		if (path.size()<2):
			path=[]
			set_fixed_process(false)
			var curr = anim.get_current_animation()
			
			anim.set_current_animation("")
			anim.stop(true)
			get_node("Sprite").set_frame(frames[curr])

			emit_signal("done_moving", get_global_pos())
			is_moving = false
				
	else:
		anim.stop(true)
		set_fixed_process(false);
		anim.set_current_animation("")
		is_moving = false



func update_path(start, end, nav):
	# generate a path 
	# note: optimize = false to keep trace traveling along the iso grid
	var p = nav.get_simple_path(start, end, false) 
	
	path=Array(p) 
	path.invert()
	
	general_direction = rad2deg(begin.angle_to_point(end))
	anim.set_active(true)

	destination = end
	set_fixed_process(true) # start walkin'



func _ready():
	#nav = get_node("/root/scene/env/nav")
	nav = get_tree().get_current_scene().find_node("nav")
	spr = find_node("Sprite")
	anim = find_node("anim")
	last_pos = get_pos()
	
	is_moving = false
	
	if( front_texture == null ):
		front_texture = spr.get_texture()
		
	# don't break if there is no back texture set
	if( back_texture == null):
		back_texture = front_texture
	
	if( ! get_tree().has_user_signal("start_moving") ):
		get_tree().add_user_signal("start_moving", ["from", "to", "path"])
	
	if( ! get_tree().has_user_signal("done_moving") ):
		get_tree().add_user_signal("done_moving", ["at"])
		
	if( ! get_tree().has_user_signal("oriented") ):
		get_tree().add_user_signal("oriented", ["dir", "at"])
		
	set_fixed_process(false)
