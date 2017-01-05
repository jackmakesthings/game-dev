# Utility & shared methods (autoloaded as utils)
extends Node

const config_path = "user://config.cfg"
const savefile_path = "res://savegames"

const PLAYER_CLASS = preload("res://systems/character/_SimpleWalker.gd")

var debug = true

var orientations = ['N', 'NW', 'W', 'SW', 'S', 'SE', 'E', 'NE', 'N']
var deg_per_orient = 360 / (orientations.size() - 1)

## Data methods ##

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

# save_cfg(data)
# Write an object (section/key/val) to config
func save_cfg(data):
	var f = ConfigFile.new()
	f.load(config_path)
	for s in data:
		f.set_value(s.section, s.key, s.val)
	f.save(config_path)
	
# load_cfg
# Parse and return the config settings
func load_cfg():
	var f = ConfigFile.new()
	f.load(config_path)
	return f


## Game saving - work in progress

####### save_game(data, dest)
# data = object containing data to save to file
# dest = file path (should be like res://savegames/file.txt)
func save_game(data, filename):
	if( data == null ):
		return false
	var filex = File.new()
	var error
	var dest = savefile_path + '/' + filename
	error = filex.open(dest, File.WRITE)
	if (filex.is_open()):
		filex.store_string(data.to_json())
		filex.close()
		return true
	else:
		return error

###### load_game(path)
# pass in the path to a savefile, this will load and instantiate it
func load_game(path):
	var data = get_json(path)
	#goto_scene(path, data)

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


func save():
	var data = {}
	data['floor'] = Game.Floor
	data['position'] = Game.Player.get_global_pos()
	data['inventory'] = Inventory.get_contents()
	save_game(data, 'save.txt')

		
## Input helpers ##

# is_click(ev)
# helper for checking the nature of an input event
func is_click(ev):
	return (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index == 1)

# fake_click(position, flags)
# Simulate a click somewhere on the map
# Use "flags" if extra options are needed
func fake_click(position, flags=0):
	var ev = InputEvent()
	ev.type = InputEvent.MOUSE_BUTTON
	ev.button_index=BUTTON_LEFT
	ev.pressed = true
	ev.global_pos = position
	ev.meta = flags
	get_tree().input_event(ev)


## Misc. utilities ##

# Player checking; currently used by NPCs to trigger interactions

# Identify whether a node is the Player or not
func is_player(node):
	if node extends PLAYER_CLASS:
		return true
	else:
		return false

# Check for the presence of the Player within a given trigger area
func is_player_nearby(trigger):
	var nearby_bodies
	var player_found = false
	nearby_bodies = trigger.get_overlapping_bodies()
	for body in nearby_bodies:
		if is_player(body):
			player_found = true
		else:
			continue
	return player_found


# Compass direction parsing	

# This converts a simple Vector2 into an NESW string
# (useful for setting animations on moving characters)
func get_orient(vector):
#	print(vector)
	if vector.x > .3:
		if vector.y > .3:
			return 'SE'
		elif vector.y < -.3:
			return 'NE'
		else:
			return 'E'
	elif vector.x < -.3:
		if vector.y > .3:
			return 'SW'
		elif vector.y < -.3:
			return 'NW'
		else:
			return 'W'
	else:
		if vector.y >= 0:
			return 'S'
		else:
			return 'N'
			
# Finds the NESW orientation from one vector to another
func get_orient_between(from, to):
	var angle_to_pt = rad2deg(from.angle_to_point(to))
	if angle_to_pt < 0:
		angle_to_pt += 360.0
		
	var sector = round(angle_to_pt/deg_per_orient)
	return orientations[sector]
	
# Finds the NESW orientation from one *node* to another
func get_orient_between_nodes(from, to):
	return get_orient_between(from.get_global_pos(), to.get_global_pos())


# Just a wrapper for print(), to make debug-only logging a little easier
func debug(text):
	if debug:
		print(text)
		
		
# Array manipulation!
# Take an array, make a copy, shuffle the copy and return it
# (Leaves the original intact.)

func shuffle(array):
	var new_array = Array()
	new_array.resize(array.size())
	for i in range(1, new_array.size()):
		randomize()
		var j = floor(randf() * (i + 1))
		var temp = array[i]
		new_array[i] = array[j]
		new_array[j] = temp
	return new_array	
		
