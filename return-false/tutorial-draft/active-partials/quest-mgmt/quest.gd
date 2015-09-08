#quest class - expects external data, creates branch nodes from json,
# attaches them to npcs based on references (names)
# 9/7/15

extends Node

# Q_ID = quest id, i.e. "tutorial" or "0_diagnostic"
export(String) var Q_ID

# important nodes we'll need to reference, once we're in the scene
var game
var paths
var utils

var quest_root
var npc_root

# todo: see if this can be removed now
var branch_group = str(Q_ID) + "-branches"

# each quest gets its own file, which gets set as data_source
# this is then parsed to create a data object
export(String, FILE) var data_source
var data = {}

# future aliases to data["branches"] and data["actors"]
var branches = {}
var actors = []

# state data comes from the file set as data_source
var states
var prev_state = null
var current_state = 0 setget set_current_state,get_current_state
var init_at = "20"
var end_at = "100"

# logs/journals also come from the data file
# we preload the Branch class to use as a template later
var logs
var log_base
var Branch = preload("res://active-partials/quest-mgmt/quest_branch.gd")

# various boolean conditions this quest can be checked for
var branches_ready = false
var is_ready       = false
var is_active      = false
var is_complete    = false

# event-based signals we can hook into later
signal branches_added(quest_id, actors)
signal branches_removed(quest_id, actors)
signal state_changed(quest_id, old_state, new_state)
signal quest_completed(quest_id, end_at)


func load_data(data_source):
	data = utils.get_json(data_source)
	branches = data["branches"]
	logs = data["logs"]

	# make sure our file and this quest are on the same page
	if data.has("id") and not (data["id"] == Q_ID):
		Q_ID = data["id"]
		branch_group = Q_ID + "-branches"
		
	is_ready = true

# apply data from our parsed json to the Branch template
# and add the resulting branch node to the scene as children
func create_branches_from_data(data):
	for branch in branches:
		var branch_node = Branch.new()
		for key in branch:
			branch_node.set(key, branch[key])
		branch_node.set_name(Q_ID + "-" + branch["actor"])
		add_child(branch_node)
		branch_node.add_to_group(branch_group)

# this will generally come right after the function above
# it takes the child branches of this quest node and moves them
# so they're children of their associated NPCs instead
func attach_branches():
	var branch_nodes = get_children()
	for branch in branch_nodes:
	
		remove_child(branch)
		# this is how we selectively ignore nodes that aren't branches
		if branch.has_method("_at_state"):
			var actor_ref = branch.get("actor")
			
			if not npc_root.has_node(actor_ref):
				print("Error; no NPC found called ", actor_ref)
				return
			else:
				var actor = npc_root.get_node(actor_ref)
				branch.set("Q_ID", Q_ID)
				branch.set_name(Q_ID)
				branch.set("owned_by", self)
				actor.add_child(branch)
				if ( actors.find(actor.get_name()) == -1 ):
					actors.append(actor_ref)
		else:
			return
			
	branches_ready = true	
	emit_signal("branches_added", Q_ID, actors)


func detach_branches():
	var branch_nodes = get_tree().get_nodes_in_group(branch_group)
	for branch in branch_nodes:
		branch.queue_free()
	emit_signal("branches_removed", Q_ID, actors)

func is_active():
	return is_active

func is_ready():
	return is_ready

func is_attached():
	return branches_ready

func activate(start_state="20"):
	if( is_active() == true ):
		print("Quest ", Q_ID, " is already active.")
		return
	else:
		self.add_to_group("active_quests")
		create_branches_from_data(data)
		attach_branches()
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
	prev_state = self.current_state
	current_state = state
	game.quest_states[Q_ID] = state
	
	if( logs.has(state) ):
		var _log = logs[state]
		_log["entry_id"] = Q_ID
		log_base.update_journal(_log)
		
	emit_signal("state_changed", Q_ID, prev_state, state)


func get_current_state():
	return current_state


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
	paths = get_node("/root/paths")
	
	npc_root = get_node("/root/scene/stage/nav/floor/bodies")
	quest_root = get_parent()

	add_user_signal("branches_added", [Q_ID, actors])
	add_user_signal("branches_removed", [Q_ID, actors])
	add_user_signal("state_changed", [Q_ID, prev_state, current_state])
	add_user_signal("quest_completed", [Q_ID, end_at])



func _setup():
	if (data_source == null):
		print("Error; cannot initialize quest with no data!")
		return
	else:
		load_data(data_source)



func _ready():
	game = get_node("/root/game")
	log_base = get_node("/root/scene/journal_ui")
	quest_root = get_parent()
	_setup()
	activate()


func _test():
	pass
	#activate()
