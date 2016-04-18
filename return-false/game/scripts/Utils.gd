# Utility & shared methods (autoloaded as utils)
extends Node

const config_path = "user://config.cfg"
const savefile_path = "res://savegames"

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
