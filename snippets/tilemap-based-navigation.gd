structure:
Scene (node2d)
  Navigation2D
    TileMap
  End (marker)
  Actor (KinematicBody2D)
    Sprite
    CollisionShape2D

script nav.gd on navigation

extends Navigation2D

var actor = null
var tmap = null
var path = []
var speed = 120

func _ready():
	actor = get_node("../Actor")
	tmap = get_node("TileMap")
	fill_tilemap() # change empty tiles to invisible tile with just navigation poly
	delete_squares() # remove nav tiles near the walls
	remove_child(tmap) # readd tilemap, otherwise navigation poly wont work
	add_child(tmap) 
	generate_path( actor.get_pos(), get_node("../End").get_pos() )
	print(path)
	draw_path()
	set_process_input(true)

func fill_tilemap(): 
	var tset = tmap.get_tileset()
	var end = tmap.world_to_map(Vector2(800,600))
	for x in range(end.x):
		for y in range(end.y):
			if tmap.get_cell(x,y) == -1:
				tmap.set_cell(x,y,1)

func generate_path(from, to):
	path = Array( get_simple_path( from, to ) )
	update()

func delete_squares():
	var end = tmap.world_to_map(Vector2(800,600))
	for x in range(end.x):
		for y in range(end.y):
			if tmap.get_cell(x,y) == 0:
				for xx in [-1,0,1]:
					for yy in [-1,0,1]:
						if xx == 0 and yy == 0:
							continue
						if tmap.get_cell(x+xx,y+yy) == 1:
							tmap.set_cell(x+xx,y+yy,-1)

func _input(ev):
	if ev.type == InputEvent.KEY and !ev.is_echo():
		if Input.is_key_pressed( KEY_SPACE ):
			set_fixed_process( !is_fixed_processing() )
	if ev.type == InputEvent.MOUSE_BUTTON:
		get_node("../End").set_pos(ev.pos)
		generate_path( actor.get_pos(), ev.pos)
		#_draw()
		#set_process_input( !is_processing_input() )
		set_fixed_process( true )
		

func _fixed_process(d):
	#draw_path()
# basically navpoly demo script. I just rather remove first elements instead of last
	if path.size() > 1:
		var movement = d * speed
		var pfrom = path[0]
		var pto = path[1]
		var dist = pfrom.distance_to(pto)
		if dist <= movement:
			path.remove(0)
			printt(path)
		else:
			path[0] = pfrom.linear_interpolate( pto, movement/dist )
			#draw_path()
		var atpos = path[0]
		actor.move_to( atpos )
		
		
		
#		if actor.is_colliding():
#			var n = actor.get_collision_normal()
#			var motion = atpos - actor.get_pos()
#			motion = n.slide(motion)
#			actor.move(motion)
		
		if path.size() < 2:
			path = []
			set_fixed_process(true)
	else:
		set_fixed_process(true)

func _draw():
	for i in range(path.size()-1):
		draw_line( path[i+1], path[i], Color(1,0,0,0.3), 2 )

func draw_path():
	for i in range(path.size()-1):
		draw_line( path[i], path[i+1], Color(1,0,0,0.3), 2 )
