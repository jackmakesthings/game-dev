## QuestManager base script (work in progress)
# Creates and updates quests, and communicates with other Managers
# (currently that's just the NPC one)
extends Node

var QuestBase = preload("res://sandbox/quest-draft.gd")


func add_quest(data):
	var Q = QuestBase.new(data)
	add_child(Q)
	Q.add_to_group("quests")
	return Q

func remove_quest(key):
	var Qx = get_node(key)
	remove_child(Qx)
	return Qx
	
func get_quest(key):
	return get_node(key)

func get_all():
	return get_tree().get_nodes_in_group('quests')
	
func get_all_keys():
	var keys = []
	for quest in get_all():
		keys.append(quest.key)
	return keys
	
func set_state(quest_key, value):
	var Q = get_node(quest_key)
	Q.set_current_state(value)

func set_state_directly(quest, value):
	quest.set_current_state(value)	

func _ready():
	var npcman = get_tree().get_current_scene().find_node("NPCManager")
	npcman.connect("QM_update_npcs", self, "_on_update_npcs",[],1)
	_test()
	
func _on_update_npcs():
	get_tree().call_group(0, "quests", "_find_actors")



func _test():
	var data = {
		key = "first",
		actors = { "abbot": { "dialog_label": "HEY ABBOT", "states": {}}, "costello": { "dialog_label": "hey lou", "states": {}}}
	}
	var data2 = {
		key = "second",
		actors = {"abbot": { "dialog_label": "HEYYYY ABBOT", "states": {}}}
	}
	var first_quest = add_quest(data)
	var timeout = Timer.new()
	add_child(timeout)
	timeout.set_one_shot(true)
	timeout.set_wait_time(4.5)
	timeout.start()
	yield(timeout, "timeout")
	var second_quest = add_quest(data2)
	#set_state("second", 30)
