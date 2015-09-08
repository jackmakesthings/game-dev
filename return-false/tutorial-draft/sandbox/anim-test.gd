### standard walking kinematic character
### needs to be passed a reference to the Nav2D node
### walks to point of click
### includes rudimentary sprite flipping and camera follow, now working!
### 8/8/15

extends KinematicBody2D

var begin=Vector2()
var end=Vector2()
var path=[]

var nav
var front_texture
export(Texture) var back_texture

var last_pos
var anim
var general_direction

const SPEED=60.0


func _fixed_process(delta):

	var dir = rad2deg(last_pos.angle_to_point(get_global_pos()))
	print(dir)

	var vec = (last_pos - get_global_pos()).normalized()
	#print(vec)

	var new_anim
	
	if ( dir > 0 and dir < 91 ):
		new_anim = "walk-up--left"
	elif ( dir > 90 and dir < 181 ):
		new_anim = "walk-down--left"
	elif( dir < 1 and dir > -90 ):
		new_anim = "walk-up--right"
	else:
		new_anim = "walk-down--right"
#	if last_pos.x < get_pos().x:
#		if last_pos.y > get_pos().y:
#			new_anim = "walk-down-right"
#		elif last_pos.y < get_pos().y:
#			new_anim = "walk-up-right"
#			
#	elif last_pos.x > get_pos().x:
#		if last_pos.y > get_pos().y:
#			new_anim = "walk-down-left"
#		elif last_pos.y < get_pos().y:
#			new_anim = "walk-up-left"

	if ( new_anim and anim.get_current_animation() != new_anim):
		anim.play(new_anim)

	last_pos = get_global_pos()

	if (path.size()>1):
	
		var to_walk = delta*SPEED
		while(to_walk>0 and path.size()>=2):
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			var d = pfrom.distance_to(pto)
			
			var direction = (pto - pfrom).normalized()
			var spr = get_node("Sprite")
			
			
			
			if (d<=to_walk):
				path.remove(path.size()-1)
				to_walk-=d
			else:
				path[path.size()-1] = pfrom.linear_interpolate(pto,to_walk/d)
				to_walk=0
				
		var atpos = path[path.size()-1]
		move_to(atpos);
		
		if(is_colliding()):
			var n = get_collision_normal()
			var motion = n.slide(atpos - get_global_pos())
			move(motion)
		
		else:
			pass
		
		if (path.size()<2):
			var frame
			
			#if ( 0 < general_direction < 91 ):
			if ( anim.get_current_animation() == "walk-down--left" ):
				frame = 2   # down-left
			#elif ( general_direction > 90 and general_direction < 181 ):
			elif( anim.get_current_animation() == "walk-up--left" ):
				frame = 1 # up-left
			#elif( general_direction < 1 and general_direction > -90 ):
			elif( anim.get_current_animation() == "walk-up--right" ):
				frame =  0 # up-right
			elif( anim.get_current_animation() == "walk-down--right" ):
				frame = 3   # down-right
#			
#			
			#anim.set_active(false)
			path=[]
			
			set_fixed_process(false)
			anim.stop(true)
			if( frame ):
				get_node("Sprite").set_frame(frame)
				
	else:
		anim.stop(true)
		set_fixed_process(false);



func update_path(begin, end, nav):
	var p = nav.get_simple_path(begin,end,false) # not documented yet
	path=Array(p) # Vector2array is overly complex, convert path to a normal array
	path.invert() # not documented yet
	general_direction = rad2deg(begin.angle_to_point(end))
	anim.set_active(true)
	set_fixed_process(true) # keep on movin'

func _ready():
	front_texture = get_node("Sprite").get_texture()
	back_texture = front_texture
	anim = get_node("anim")
	
	last_pos = get_pos()

	set_fixed_process(true)

