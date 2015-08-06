
extends "nav-walker.gd"

# member variables here, example:
# var a=2
# var b="textvar"

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
		
		move_to(atpos);
		# set_going_to(atpos);
		
		if(get_node(".").is_colliding()):
			print("!!!")
			# get_node("/root/base/Area2D/Navigation2D/label").text = "OH HI";
			var n = get_collision_normal()
			var motion = n.slide(atpos - get_pos());
			move(motion);
		
		else:
			pass
			#get_node("label").text = ""
		
		if (path.size()<2):
			path=[]
			set_fixed_process(false)
				
	else:
		set_fixed_process(false);