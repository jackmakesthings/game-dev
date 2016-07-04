# Sample config (settings) UI that reads/writes to a file
# (defined in Utils, where the config file methods live.)

# Note - if new field types get added, make sure their setters
# are included in both the save and load functions.
extends Control

# These keys map to both the form data keys
# and the nodes where they're input, for convenience.
var settings = ["custom_string", 
								"custom_number", 
								"custom_bool", 
								"custom_options", 
								"custom_color"] 

# Start by populating the fields from the existing config file
func _ready():
	load_config()


# This both parses the data in the fields
# and writes it to our config file. It's connected
# directly to the Save button in this demo.
func save_config():
	var config_data = []

	for setting in settings:
		var _node = find_node(setting)
		var _val 
		
		# Different nodes handle their values differently
		if _node.has_method('get_value'):
			_val = _node.get_value()
		elif _node extends ColorPickerButton:
			_val = _node.get_color()
		elif _node.has_method('get_text'):
			_val = _node.get_text()
		else:
			_val = "nope"
	
	  # However we get the value, throw it into a data object
		var _obj = { "section": "global", "key": setting, "val": _val }
		config_data.append(_obj)
		
	Utils.save_cfg(config_data)
	
	# Eventually, this will probably just close the UI
	# and maybe show a 'saved!' popup or something.
	find_node("save").set_text("saved!")
	
	
	
# This is the companion to save_config; it reads values
# from the file and loads them into the UI. It's called once
# immediately when the UI loads, and is also hooked up indirectly
# to the Cancel button (will revert fields to their saved value)	
func load_config():
	var cfg = Utils.load_cfg()
	var keys = cfg.get_section_keys("global")
	
	for key in keys:
		if cfg.has_section_key('global', key):
			var _key = key 
			var _val = cfg.get_value("global", _key)
			var _node = find_node(_key)
			
			if _node.has_method('set_value'):
				_node.set_value(_val)
			elif _node extends ColorPickerButton:
				_node.set_color(_val)
			elif _node.has_method('set_text'):
				_node.set_text(str(_val))
			else:
				print("not sure what to do with ", str(_val))


# This is hooked up to Cancel in this demo; 
# semantic wrapper on load_config.
func revert_changes():
	load_config()		