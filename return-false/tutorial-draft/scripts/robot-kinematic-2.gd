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

const SPEED=170.0


func _fixed_process(delta):

	if (path.size()>1):
	
		var to_walk = delta*SPEED
		while(to_walk>0 and path.size()>=2):
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			var d = pfrom.distance_to(pto)
			
			var direction = (pto - pfrom).normalized()
			var spr = get_node("Sprite")
			
			
			### quick and dirty sprite swapping/flipping
			### keeps trace facing the right direction
			### will probably be replaced by keyframes later
			if( direction.y > 0 ):
				spr.set_texture(front_texture)
				if( direction.x < 0 ):
					spr.set_flip_h(false)
				else:
					spr.set_flip_h(true)
			else:
				spr.set_texture(back_texture)
				if( direction.x < 0 ):
					spr.set_flip_h(true)
				else:
					spr.set_flip_h(false)
			
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
			var motion = n.slide(atpos - get_global_pos());
			move(motion);
		
		else:
			pass
		
		if (path.size()<2):
			path=[]
			set_fixed_process(false)
				
	else:
		set_fixed_process(false);



func update_path(begin, end, nav):
	var p = nav.get_simple_path(begin,end,false) # not documented yet
	path=Array(p) # Vector2array is overly complex, convert path to a normal array
	path.invert() # not documented yet
	set_fixed_process(true) # keep on movin'

func _ready():
	front_texture = get_node("Sprite").get_texture()
	set_fixed_process(true)

