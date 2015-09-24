# utils & helpers
# used as an autoload at /root/utils
extends Node

# TODO: is this still being used?
export(String, FILE) var file = "res://assets/dialogue-tree-json.txt"

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
		#for key in data:
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


func exit_game():
	pass


func new_game(filename):
	var data = {}
	data["scene"] = "res://main.xml"
	data["timestamp"] = OS.get_time()
	
	var dest = "res://savegames/" + filename + ".txt"
	# TODO: should have a file.exists? check here
	save_game(data, dest)
	goto_scene(data["scene"], data)



# fake_click(position, flags)
# Simulate a click somewhere on the map - used by NPCs
# to "attract" the player character over to them
# Use "flags" if extra options are needed
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
static func angle_to_compass(angle):

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



func goto_scene(path, data):
	var current_scene = get_tree().get_current_scene()
	call_deferred("def_goto_scene",path, data)


func def_goto_scene(path, loaded):   
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene( current_scene )
	
	#yield(current_scene, "")
	
	if( loaded == null ):
		return
		
	if( loaded.has("player_x") and loaded.has("player_y")):
		if( get_tree().get_current_scene().get("player")):
			var player = get_tree().get_current_scene().get("player")
			player.set_pos(Vector2(loaded["player_x"], loaded["player_y"]))
			print(loaded)
	
	if( loaded.has("quest_states") ):
		for q in loaded["quest_states"]:
			print("savefile has quest ", q, " at state ", loaded["quest_states"][q])
			get_node("/root/game").update_quest(q, loaded["quest_states"][q])


func dprint(whatever):
	if( debug ):
		print(whatever)




func dprintt(whatever):
	if( debug ):
		printt(whatever)