
extends Control

var key = "main"
var all_quests = ["main", "other"]

var utils
var loaded_data = {}

var button_holder
var text_holder

# member variables here, example:
# var a=2
# var b="textvar"

var branch_data_file = "res://dynamic-node-tests/data/main_quest_npc1.txt"

func _enter_tree():
	utils = get_node("/root/utils")
	loaded_data = utils.get_json(branch_data_file)
	pass


#####
# debugs and utilities

func console(args):
	var txtstring = str(args)
	text_holder.newline()
	text_holder.add_text(args)
	
func update_quests():
	for q in all_quests:
		var qs = Globals.get(q + "_quest_state")
		console(q + ": " + str(qs))

#######
# Parsing & processing data 

func get_text(state):
	return loaded_data[str(state)]["text"]

func get_responses(state):
	return loaded_data[str(state)]["responses"]

func make_actions_from_data(response):
	var actions = []
	for action in response["actions"]:
		var fref = {}
		fref.f = action["func"]
		if( action.params.size() > 0 ):
			fref.p = action.params
		else:
			fref.p = []
		#print(fref)
		actions.append(fref)
	return actions

func make_buttons_for_state(state):
	var responses = get_responses(state)
	for r in responses:
		var a = make_actions_from_data(r)
		var n = Button.new()
		n.set_text(r["text"])
		n.set_v_size_flags(2)
		n.set_h_size_flags(2)
		for act in a:
			n.connect("pressed", self, act.f, act.p)
			#console("Connected a response to " + act.f + " with params " + str(act.p))
		button_holder.add_child(n)



#####
#####
# Quest-related signals

func set_branch_state(state, branch):
	var var_name
	
	text_holder.clear()
	if( branch == "this" ):
		var_name = self.key + "_quest_state"
		Globals.set(var_name, state)
	#	Globals.set("main_quest_state", state)
		#self.set_state(state)
	else:
		var_name = branch + "_quest_state"
		Globals.set(var_name, state)
		#console("If branch " + branch + " existed, it would now be at state " + str(state))
	#console("Updated branch " + branch + " to state " + str(state))
	update_quests()

func continue_dialog_at(state, branch):
	text_holder.clear()
	if( branch == "this" ):
		console("Dialog box: " + loaded_data[str(state)]["text"])
		if( loaded_data[str(state)]["responses"].size() > 0 ):
			for c in button_holder.get_children():
				c.queue_free()
			make_buttons_for_state(str(state))
	else:
		console("Dialog box would switch subjects here, to quest " + branch + " at state " + str(state))
	update_quests()

func close_dialog():
	text_holder.clear()
	#console("Closed dialog box.")
	update_quests()
	console("(Dialog box is closed.)")
	#text_holder.clear()


func _ready():
	print("ready")
	button_holder = get_child(0)
	text_holder = get_node("console")
	set_branch_state("20", "main")
	set_branch_state("20", "other")
	make_buttons_for_state("20")
	# Initialization here
	pass


