var next_anim=""
var next_mirror=false

if (dir==Vector2() and speed.length()<IDLE_SPEED):
	next_anim="idle"
	next_mirror=false 
elif (speed.length()>IDLE_SPEED*0.1):
	var angle = atan2(abs(speed.x),speed.y)	
	
	next_mirror = speed.x>0
	if (angle<PI/8):
		next_anim="bottom"
		next_mirror=false
	elif (angle<PI/4+PI/8):
		next_anim="bottom_left"
	elif (angle<PI*2/4+PI/8):
		next_anim="left"
	elif (angle<PI*3/4+PI/8):
		next_anim="top_left"
	else:
		next_anim="top"
		next_mirror=false
	
		
if (next_anim!=current_anim or next_mirror!=current_mirror):
	get_node("frames").set_flip_h(next_mirror)
	get_node("anim").play(next_anim)
	current_anim=next_anim
	current_mirror=next_mirror