
extends Navigation2D

# member variables here, example:
# var a=2
# var b="textvar"
var begin=Vector2()
var end=Vector2()
var path=[]

#my stuff
	var lbl = get_node("Label")
	var loc=Vector2()
	var poly=[]
	const OFFSET=30.0

const SPEED=200.0

func color(pos):
	var posarray=pos;
	var x0 = posarray[0];
	var y0 = posarray[1];
	var x1=x0 - 2*OFFSET;
	var x2=x0 + 2*OFFSET;
	var y1=y0 - OFFSET;
	var y2=y0 + OFFSET;
	
	
	var arr1 = Vector2(x1, y0);
	var arr2=Vector2(x0, y1);
	var arr3=Vector2(x2,y0);
	var arr4=Vector2(x0,y2);
	poly=[arr1,arr2,arr3,arr4];
	get_node("Polygon2D").set_polygon(poly);
	#[arr1,arr2,arr3,arr4]);

func _process(delta):


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
		get_node("agent").set_pos(atpos)
		
		if (path.size()<2):
			path=[]
			set_process(false)
				
	else:
		loc = get_node("agent").get_pos();
		color(loc);
		set_process(false);



func _update_path():

	var p = get_simple_path(begin,end,true) # not documented yet
	path=Array(p) # Vector2array is overly complex, convert path to a normal array
	path.invert() # not documented yet

	set_process(true) # keep on movin'


func _input(ev):
	if (ev.type==InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		begin=get_node("agent").get_pos()
		end=ev.pos - get_pos()    # convert our endpoint to be relative from start point
		_update_path()
		#color(end)

func _ready():
	# Initialization here
	poly = get_node("Polygon2D").get_polygon();
	set_process_input(true)
	pass


