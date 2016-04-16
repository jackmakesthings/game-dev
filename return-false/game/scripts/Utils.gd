# Utility & shared methods (autoloaded as utils)
extends Node



func is_click(ev):
	return (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index == 1)



# Save/load config data
var config_path = "user://config.cfg"


func save_cfg(data):
	var f = ConfigFile.new()
	f.load(config_path)
	for s in data:
		f.set_value(s.section, s.key, s.val)
	f.save(config_path)
	

func load_cfg():
	var f = ConfigFile.new()
	f.load(config_path)
	return f


# Testing for the config functions
func test_cfg():
	save_cfg([
		{
			section = "Character",
			key = "pronouns",
			val = "she/her"
		}
	])

	var data = load_cfg()
	var pronouns = data.get_value("Character", "pronouns")
	print("You chose to use ", pronouns, ".")
