# utils & helpers

extends Node

export(String, FILE) var file = "res://assets/dialogue-tree-json.txt"

var debug = true

# get_json(file)
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


func save_game(data, dest):
	if( data == null ):
		return false
	if not (dest.begins_with('res://') or dest.begins_with('user://')):
		return false
	
	
	var filex = File.new()
	var error
	
	error = filex.open(dest, File.WRITE)
	#now write
	if (filex.is_open()):
	
		for key in data:
			filex.store_string(data.to_json())
			
		filex.close()
		return true
	else:
		return error
	

func load_game(src):
	pass

func exit_game():
	pass



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










func dprint(whatever):
	if( debug ):
		print(whatever)




func dprintt(whatever):
	if( debug ):
		printt(whatever)