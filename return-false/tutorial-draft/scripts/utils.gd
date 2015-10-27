# utils & helpers
# used as an autoload at /root/utils
extends Node

# not currently in use here, but implemented elsewhere, 
# should probably be here though
const SAVEFILE_DIR = "res://savegames"


var debug = true
var current_scene



func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


###### get_json(file)
# Load and parse data from a json file (by path)
func get_json(file):
	var json = File.new()
	json.open(file, 1)

	var d = {}
	var err = d.parse_json(json.get_as_text())
	if (err!=OK):
		print("error parsing json")
		return {}
	else:
		return d



####### save_game(data, dest)
# data = object containing data to save to file
# dest = file path (should be like res://savegames/file.txt)
func save_game(data, dest):
	if( data == null ):
		return false
	if not (dest.begins_with('res://') or dest.begins_with('user://')):
		return false
	
	var filex = File.new()
	var error
	
	error = filex.open(dest, File.WRITE)

	if (filex.is_open()):
		filex.store_string(data.to_json())
		filex.close()
		return true
	else:
		return error



###### load_game(path)
# pass in the path to a savefile, this will load and instantiate it
# (path should be something like "res://savegames/savefile.txt")
func load_game(path):
	var data = get_json(path)
	goto_scene(path, data)



####### quit_game
# super simple; stuff like confirming the action happens elsewhere
func quit_game():
	print("Bye!")
	get_tree().quit()



##### new_game(filename)
# saves a basically-blank file at the specified path
# then drops us into our starting scene (TODO: make this a constant)
func new_game(filename):
	var data = {}
	data["scene"] = "res://main.xml"
	data["timestamp"] = OS.get_time()
	
	var dest = "res://savegames/" + filename + ".txt"
	# TODO: should have a file.exists? check here

	save_game(data, dest)
	goto_scene(data["scene"], data)



##### fake_click(position, flags)
# Simulate a click somewhere on the map - used by NPCs
# to "attract" the player character over to them
# Use "flags" if extra options are needed (not implemented as of yet)
func fake_click(position, flags=0):
	var ev = InputEvent()
	ev.type = InputEvent.MOUSE_BUTTON
	ev.button_index=BUTTON_LEFT
	ev.pressed = true
	ev.global_pos = position
	ev.meta = flags
	get_tree().input_event(ev)



# angle_to_compass(angle)
# needs revision, but this is for mapping positions and directions
func angle_to_compass(angle):

	var compass_dir
	if( -25 <= angle and angle < 25 ):
		compass_dir = "N"
	elif( 25 <= angle and angle < 70 ):
		compass_dir = "NW"
	elif( 70 <= angle and angle < 116 ):
		compass_dir = "W"
	elif( 116 <= angle and angle < 155 ):
		compass_dir = "SW"
	elif(( 155 <= angle and angle <= 180 ) or ( -180 <= angle and angle <= -155 )):
		compass_dir = "S"
	elif( -70 <= angle and angle < -25 ):
		compass_dir = "NE"
	elif( -116 <= angle and angle < -70 ):
		compass_dir = "E"
	elif( -155 <= angle and angle < -116 ):
		compass_dir = "SE"
	else:
		compass_dir = "S"
		
	return compass_dir


# a more elegant (if less detailed) take, found on github
# https://github.com/vnen/godot-rpg2d
func get_direction_from_angle(angle):
	if(angle >= -((3 * PI) / 4) and angle < -(PI / 4)):
		return "N"
	elif(angle >= -(PI / 4) and angle < (PI / 4) ):
		return "E"
	elif(angle >= (PI / 4) and angle < ((3 * PI) / 4)):
		return "S"
	return "W"
	

# fn() - simple string transformer
# builds a path/filename string from arbitrary text
# used by the load/save submenus and probably elsewhere soon
func fn(text):
	return "" + SAVEFILE_DIR + "/" + text + ".txt"



##### generic shorthand for timeouts
func wait(time):
	var t = Timer.new()
	t.set_one_shot(true)
	t.set_wait_time(time)
	return t


###### goto_scene - a function in two parts
# using call_deferred ensures we won't close a scene
# while we're still using it
func goto_scene(path, data):
	current_scene = get_tree().get_current_scene()
	print( current_scene )
	#if ( current_scene.is_processing() ):
	current_scene.set_process(false)
	call_deferred("def_goto_scene",path, data)

func def_goto_scene(path, loaded):

	var s = ResourceLoader.load(path)
	   
	current_scene.free()
	current_scene = s.instance()
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene( current_scene )
	
	# if there's no data, we're done here
	if( loaded == null ):
		return
	
	# TODO: abstract out an apply_save_data method and put it here
	if( loaded.has("player_x") and loaded.has("player_y")):
		if( get_tree().get_current_scene().get("player")):
			var player = get_tree().get_current_scene().get("player")
			player.set_pos(Vector2(loaded["player_x"], loaded["player_y"]))
			print(loaded)
	
	if( loaded.has("quest_states") ):
		for q in loaded["quest_states"]:
			print("savefile has quest ", q, " at state ", loaded["quest_states"][q])
			get_node("/root/game").update_quest(q, loaded["quest_states"][q])