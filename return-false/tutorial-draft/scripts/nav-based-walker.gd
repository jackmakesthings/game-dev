# basic input-driven navigation walker, good base for player char

extends KinematicBody2D

# pass in the appropriate nodes
var game
var nav

# navigation/position vars
var begin=Vector2()
var end=Vector2()
var path=[]

# status
var is_moving = false

# how much ground to cover per delta
const SPEED=150.0

signal done_moving

func _fixed_process(delta):

	if (path.size()>1):
	
		is_moving = true
		
		var to_walk = delta*SPEED
		while(to_walk>0 and path.size()>=2):
		
			var pfrom = path[path.size()-1]
			var pto = path[path.size()-2]
			var d = pfrom.distance_to(pto)
			
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
			is_moving = false
			emit_signal("done_moving")
			set_fixed_process(false)
			
	else:
		set_fixed_process(false);

func announce_end(): 
	print( "player is done moving")

func update_path(begin, end):
	var p = nav.get_simple_path(begin,end,true)
	path=Array(p)
	path.invert() 
	set_fixed_process(true) # keep on movin'

func _ready():
	game = get_node("/root/game")
	nav = game.get_node("Navigation2D")
	add_user_signal("done_moving")
	#connect("done_moving", self, "announce_end")
