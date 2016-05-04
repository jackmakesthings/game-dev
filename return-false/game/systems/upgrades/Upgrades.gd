# Skill/upgrade/currency management


########
# Locals

var free_chips = 1000 setget set_free_chips,get_free_chips

var Hardware = 1
var Software = 1
var Social = 1
var Subvert = 1

const STEPS = {
	0: 0,
	1: 0,
	2: 100,
	3: 200,
	4: 300,
	5: 400
}

###################
# Setters & getters

func set_free_chips(quantity):
	free_chips = quantity
	
func get_free_chips():
	return free_chips

func add_chips(quantity):
	set_free_chips(free_chips + quantity);

func remove_chips(quantity):
	set_free_chips(free_chips - quantity)

func get_skill(which):
	return self[which]

func set_skill(which, value):
	self[which] = value;

func get_next_step(target_skill):
	var next_step = get_skill(target_skill) + 1
	if next_step > 5:
		return -1
	return STEPS[next_step]

func get_prev_step(target_skill):
	var prev_step = get_skill(target_skill) - 1
	if prev_step < 0:
		return -1
	return STEPS[prev_step]



#########
# Actions

# Upgrade
func try_upgrade(target_skill):
	var required = get_next_step(target_skill)

	if required == -1:
		update_UI("ERROR; Subroutine '" + target_skill + "' is already optimized.")
		return false
	elif required > free_chips:
		update_UI("ERROR; insufficient resources.")
		return false
	else:
		upgrade(target_skill, required)

func upgrade(target_skill, cost):
	remove_chips(cost)
	set_skill(target_skill, get_skill(target_skill) + 1)
	update_UI()


# Downgrade
func try_downgrade(target_skill):
	var required = get_prev_step(target_skill)

	if required == -1:
		update_UI("ERROR; no resources allocated to subroutine " + target_skill)
		return false
	else:
		downgrade(target_skill)
		


func downgrade(target_skill):
	var recoup = STEPS[get_skill(target_skill)]
	add_chips(recoup)
	set_skill(target_skill, get_skill(target_skill) - 1)
	update_UI()



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