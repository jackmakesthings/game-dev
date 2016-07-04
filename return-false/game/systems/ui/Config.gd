# Sample config (settings) UI that reads/writes to a file
# (defined in Utils, where the config file methods live.)

# Note - if new field types get added, make sure their setters
# are included in both the save and load functions.
extends Control

# These keys map to both the form data keys
# and the nodes where they're input, for convenience.

var defaults = {
								"custom_string": "Lorem Ipsum",
								"custom_number": 420,
								"custom_bool": false,
								"custom_options": "Robots",
								"custom_color": Color('#ffffff')
								}

var settings = defaults.keys()

var exit_confirmed = false

# Start by populating the fields from the existing config file
# and hooking up signals to change the color of the save/cancel buttons
# based on whether there are unsaved changes.
# (This UI pattern can be revisited later.)
func _ready():
	load_config()
	connect_marker()


# Helper for reading the current value of a field in the UI
# (not to be confused with its value in the saved config file)
func get_field_val(setting):
	var _node = find_node(setting)
	var _val 
	
	# Different nodes handle their values differently
	if _node.has_method('get_value'):
		_val = _node.get_value()
	elif _node extends ColorPickerButton:
		_val = _node.get_color()
	elif _node extends CheckButton:
		_val = _node.get('is_pressed')
	elif _node.has_method('get_text'):
		_val = _node.get_text()
	else:
		_val = "nope"
	return _val
	
	
# Complementary to previous function, this just updates a value
# in the UI (but doesn't touch the config file itself).	
func set_field_val(setting, _val):
	var _node = find_node(setting)
	
	# Different nodes handle their values differently
	if _node.has_method('set_value'):
		_node.set_value(_val)
	elif _node extends ColorPickerButton:
		_node.set_color(_val)
	elif _node extends CheckButton:
		_node.set('is_pressed', _val)	
	elif _node.has_method('set_text'):
		_node.set_text(str(_val))
	else:
		print("not sure what to do with ", str(_val))
	
	
	
# This both parses the data in the fields
# and writes it to our config file. It's connected
# directly to the Save button in this demo.
func save_config():
	var config_data = []

	for setting in settings:
		var _val = get_field_val(setting)
	
	  # However we get the value, throw it into a data object
		var _obj = { "section": "global", "key": setting, "val": _val }
		config_data.append(_obj)
		
	Utils.save_cfg(config_data)
	
	# Eventually, this will probably just close the UI
	# and maybe show a 'saved!' popup or something.
	find_node("save").set_text('saved!')
	update_marker()
	
	if exit_confirmed:
		back_to_menu()
	
	
	
# This is the companion to save_config; it reads values
# from the file and loads them into the UI. It's called once
# immediately when the UI loads, and is also hooked up indirectly
# to the Cancel button (will revert fields to their saved value)	
func load_config():
	var cfg = Utils.load_cfg()
	var keys = cfg.get_section_keys('global')
	
	for key in keys:
		if cfg.has_section_key('global', key):
			var _val = cfg.get_value("global", key)
			set_field_val(key, _val)
		else:
			var _val = defaults[key]
			set_field_val(key, _val)


# This is hooked up to Cancel in this demo; 
# semantic wrapper on load_config.
func revert_changes():
	load_config()
	update_marker()
	if exit_confirmed:
		back_to_menu()
	
# Check for any unsaved edits; this can be called
# before allowing the player to go back to the main menu.
func has_unsaved_changes():
	var cfg = Utils.load_cfg()
	var keys = cfg.get_section_keys('global')
	
	for setting in settings:
		var _current = get_field_val(setting)
		var _saved = cfg.get_value('global', setting)
		
		# force-cast to str() for looser comparisons
		if str(_current) != str(_saved):
			return true			
	return false


func revert_to_defaults():
	for key in defaults:
			var _key = key 
			var _val = defaults[_key]
			set_field_val(_key, _val)
	update_marker()
			
	
func back_to_menu():
	if has_unsaved_changes():
		find_node('back').set_text('changes detected!')
		find_node('cancel').set_text('discard')
		mark_unsaved()
		exit_confirmed = true
		return
	if get_tree().get_current_scene().has_method('set_scene'):
		get_tree().get_current_scene().set_scene('res://systems/ui/Splash.tscn')


func _on_save_focus_exit():
	update_marker()


func mark_unsaved():
	find_node('save').set('custom_colors/font_color', Color('#11ff11'))
	find_node('cancel').set('custom_colors/font_color', Color('#ff1111'))
	exit_confirmed = false

func unmark():
	find_node('save').set('custom_colors/font_color', null)
	find_node('cancel').set('custom_colors/font_color', null)
	find_node('save').set_text('save')
	find_node('cancel').set_text('cancel')
	find_node('back').set_text('< back to menu')		


func connect_marker():
	var fields = get_tree().get_nodes_in_group('fields')
	for field in fields:
		if !field.is_connected('input_event', self, '_on_fields_input_event'):
			field.connect('input_event', self, '_on_fields_input_event')


func update_marker():
	if has_unsaved_changes():
		mark_unsaved()
	else:
		unmark()

func _on_fields_input_event( ev ):
	if ev.type == InputEvent.KEY or ev.type == InputEvent.MOUSE_BUTTON:
		update_marker()
