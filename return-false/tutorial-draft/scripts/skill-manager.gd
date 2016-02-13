extends Node

signal skill_updated(which, value)

var skills = {
	hardware = 3,
	software = 3,
	social = 3,
	deceit = 3
}

var max_points = 10
var MUI

func set_skill_points(key, points, cumulative):
	var new_val
	if cumulative:
		new_val = skills[key] + points
	else:
		new_val = points
		
	
	if new_val >= max_points:
		skills[key] = max_points
	elif new_val <= 0:
		skills[key] = 0
	else:
		skills[key] = new_val

	emit_signal("skill_updated", key, skills[key])
	print(skills)

	if MUI:
		var string = "Upgraded " + key + ""
		MUI.flash_popup(string)
		

func _ready():
	MUI = get_tree().get_root().find_node("message-ui")