#quest class - expects external data, creates branch nodes from json,
# attaches them to npcs based on references (names)
# 9/1/15

extends Node

export var Q_ID = "tutorial"

var game

var quest_root
var npc_root
var branch_group

var branches = {}
var actors = []

var data_source
var data = {}
var is_ready = false
var is_active = false
var is_complete = false
var utils


var states
var old_state
var new_state
var end_at
var current_state = 0

var Branch = preload("res://sandbox/_quest_branch.gd")


signal branches_added(quest_id, actors)
signal branches_removed(quest_id, actors)
signal state_changed(quest_id, old_state, new_state)
signal quest_completed(quest_id, end_at)


func load_data(data_source):
	self.set("data", utils.get_json(data_source))
	self.set("branches", data["branches"])

	if data["id"] and not (data["id"] == Q_ID):
		Q_ID = data["id"]
	branch_group = Q_ID + "-branches"
	is_ready = true


func create_branches_from_data(data):
	#get_children().clear()
	#if is_ready() == false:
	#	load_data(data_source)
	for branch in branches:
		var branch_node = Branch.new()
		for key in branch:
			branch_node.set(key, branch[key])
		branch_node.set_name(Q_ID + "-" + branch["actor"])
		add_child(branch_node)
		branch_node.add_to_group(branch_group)
		branch_node.set_owner(self)


func attach_branches():
	var branch_nodes = get_children()
	for branch in branch_nodes:
	
		remove_child(branch)
		if branch.has_method("_at_state"):
			var actor_ref = branch.get("actor")
			if not npc_root.has_node(actor_ref):
				print("Error; no NPC found called ", actor_ref)
				return
			else:	
				var actor = npc_root.get_node(actor_ref)
				#branch = branch.duplicate()
				#remove_child(branch)
				branch.set("Q_ID", Q_ID)
				branch.set_name(Q_ID)
				branch.set("owned_by", self)
				actor.add_child(branch)
				if ( actors.find(actor.get_name()) == -1 ):
					actors.append(actor_ref)
		else:
			return
	
	
		


func detach_branches():
	var branch_nodes = get_children()
	for branch in branch_nodes:
		branch.queue_free()
	emit_signal("branches_removed", Q_ID, actors)


func is_active():
	return is_active


func is_ready():
	return is_ready


func activate(start_state="20"):
	if( is_active() == true ):
		print("Quest ", Q_ID, " is already active.")
		return
	else:
		self.add_to_group("active_quests")
		create_branches_from_data(data)
		attach_branches()
		emit_signal("branches_added", Q_ID, actors)
		is_active = true
		set_current_state(start_state)
		print("Activated quest ", Q_ID , " at state ", start_state, " with actors ", actors)


func deactivate():
	if( is_active() == false ):
		print("Quest ", Q_ID, " is not active.")
		return
	else:
		self.remove_from_group("active_quests")
		detach_branches()
		is_active = false


func set_current_state(state):
	var old_state = self.current_state
	self.set("current_state", state)
	game.quest_states[Q_ID] = state
	emit_signal("state_changed", Q_ID, old_state, state)


func get_current_state():
	return self.current_state


func complete(end_at="100"):
	set_current_state(end_at)
	yield(self, "state_changed")
	deactivate()
	add_to_group("completed_quests")
	is_complete = true
	emit_signal("quest_completed", Q_ID, end_at)


#func _init(data_source_path):
#	self.data_source = data_source_path




func _enter_tree():
	game = get_node("/root/game")
	utils = get_node("/root/utils")
	npc_root = get_node("/root/scene/stage/nav/floor/bodies")
	quest_root = get_parent()

	add_user_signal("branches_added", [Q_ID, actors])
	add_user_signal("branches_removed", [Q_ID, actors])
	add_user_signal("state_changed", [Q_ID, old_state, new_state])
	add_user_signal("quest_completed", [Q_ID, end_at])



func _setup():
	if (data_source == null):
		print("Error; cannot initialize quest with no data!")
		return
	else:
		load_data(data_source)



func _ready():
	game = get_node("/root/game")
	utils = get_node("/root/utils")
	npc_root = get_node("/root/scene/stage/nav/floor/bodies")
	quest_root = get_parent()
	_setup()
	activate()


func _test():
	pass
	#activate()
