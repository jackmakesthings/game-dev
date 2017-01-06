## QuestManager base script (work in progress)
# Creates and updates quests, and communicates with other Managers
# (currently that's just the NPC one)
extends Node

var QuestBase = preload("res://systems/quests/_Quest.gd")
var QuestBranch = preload('res://systems/quests/_Quest.Branch.gd')
var QuestDataPath = 'res://data/quests.txt'


func save_current_quests():

	var filex = File.new()
	for quest in get_all():
		var questdata = inst2dict(quest)
		var error = filex.open(QuestDataPath, File.WRITE)
		if (filex.is_open()):
			filex.store_line(questdata.to_json())
			filex.close()
			return true
		else:
			return error


func load_saved_quests():

    var saved = File.new()
    if !saved.file_exists(QuestDataPath):
        return #Error!  We don't have a save to load

    # We need to revert the game state so we're not cloning objects during loading.  This will vary wildly depending on the needs of a project, so take care with this step.
    # For our example, we will accomplish this by deleting savable objects.
    var savenodes = get_tree().get_nodes_in_group("quests")
    for i in savenodes:
        i.queue_free()

    # Load the file line by line and process that dictionary to restore the object it represents
    var currentline = {} # dict.parse_json() requires a declared dict.
    saved.open(QuestDataPath, File.READ)
    while (!saved.eof_reached()):
        currentline.parse_json(saved.get_line())

        # We have to clear out a few things that inst2dict tries to set for us
        # The 'Branch' preload gets stored as a string, which we need to fix
        currentline.erase('@path')
        currentline.erase('@subpath')
        currentline.Branch = QuestBranch

        add_quest(currentline)
    saved.close()


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
	var npcman = get_parent().NPCManager
	npcman.connect("QM_update_npcs", self, "_on_update_npcs",[],1)
	load_saved_quests()
	_test()

func _on_update_npcs():
	get_tree().call_group(0, "quests", "_find_actors")
	
func _test():
	var data = {
		key = "first",
		actors = { "NPC": { "dialog_label": "HEY ABBOT", "states": { "10": { "dialogue": "HEY ABBOT", "responses": [{"text": "okay", "dialog_action": 0}]}}}}
	}
	var data2 = {
		key = "second",
		actors = { "NPC": { "dialog_label": "Some other thing", "states": { "10": { "dialogue": "This is at 20.", "responses" : [{"text": "neato", "dialog_action": 0}] }}}}
	}
	var first_quest = add_quest(data)
	var second = add_quest(data2)
	_on_update_npcs()
