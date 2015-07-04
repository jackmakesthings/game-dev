extends KinematicBody2D

var begin=Vector2()
var end=Vector2()
var path=[]

var nav


const SPEED=150.0


func _fixed_process(delta):

	if (path.size()>1):
	
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
		
		#move_to(atpos);
		set_pos(atpos)
		# set_going_to(atpos);
		
		if(is_colliding()):
			#print("!!!")
			# get_node("/root/base/Area2D/Navigation2D/label").text = "OH HI";
			var n = get_collision_normal()
			var motion = n.slide(atpos - get_global_pos());
			move(motion);
		
		else:
			pass
			#get_node("label").text = ""
		
		if (path.size()<2):
			path=[]
			set_fixed_process(false)
				
	else:
		set_fixed_process(false);



func update_path(begin, end):
	var p = nav.get_simple_path(begin,end,true) # not documented yet
	#var p = nav.get_simple_path(begin,end,true);
	path=Array(p) # Vector2array is overly complex, convert path to a normal array
	path.invert() # not documented yet

	set_fixed_process(true) # keep on movin'

func _ready():
	nav = get_tree().get_root().get_node("game/Navigation2D")
	#pass
	#set_fixed_process()
