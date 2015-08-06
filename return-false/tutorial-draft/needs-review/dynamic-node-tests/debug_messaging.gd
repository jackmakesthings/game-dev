
extends MarginContainer

# member variables here, example:
# var a=2
# var b="textvar"

# 0 = no active quests
# 1 = one active quest
# 2 = multiple active quests
var quest_status = 0
var dialogue
var responses
var mui

func check_quests():
	var q = get_tree().get_nodes_in_group("active_quests")
	if( q.size() < 1 ):
		quest_status = 0
	elif( q.size() == 1 ):
		quest_status = 1
	elif( q.size() > 1 ):
		quest_status = 2

func handle_0_quests():
	dialogue = "Can this wait? I'm in the middle of some calibrations."
	responses = [{"text":"Leave", "action":"end_dialog", "actions": [{"func":"end_dialog", "params":[]}]}]
	mui.show_dialogue(dialogue)
	mui.show_responses_from_array(responses)

func handle_1_quest():
	dialogue = "Hey, Tr4ce. What's up?"
	responses = []
	var qs = get_tree().get_nodes_in_group("active_quests")
	for q in qs:
		var response = {}
		response.text = q.get_name()
		response.action = "end_dialog"
		response.actions = [{"func":"end_dialog", "params":[]}]
		response.actions.append({"func": "set_branch", "params": [q.get_name()]})
		response.actions.append({"func": "next_dialog", "params": [q.get("state"), q.get_name()]})
		responses.append(response)
	mui.show_dialogue(dialogue)
	mui.show_responses_from_array(responses)
	
func handle_multi_quests():
	handle_1_quest()
	
func _on_npc_pressed():
	#mui.close()
	check_quests()
	mui.show()
	if( quest_status == 0 ):
		handle_0_quests()
	else:
		handle_1_quest()

func _ready():
	mui = get_node("Control")
	get_node("npc").connect("pressed", self, "_on_npc_pressed")
	# Initialization here
	pass


