# Skill/upgrade/currency management

extends "res://systems/upgrades/Upgrades.gd"

# Init and update
func update_UI(text=null):
	var chips_node = find_node("Label")
	if text:
		chips_node.set_text(text)
	else:
		chips_node.set_text("Chips: "+ str(free_chips))

	for s in ['Hardware', 'Software', 'Social', 'Subvert']:
		var skill_node = find_node(s)
		var skill_val = get_skill(s)
		skill_node.set_value(skill_val)

func _ready():
	set_free_chips(1500)
	update_UI()