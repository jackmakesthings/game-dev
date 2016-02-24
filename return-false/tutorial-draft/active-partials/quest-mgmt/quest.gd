#quest class - expects external data, creates branch nodes from json,
# attaches them to npcs based on references (names)
# 2/13/16

extends Node

# Q_ID = quest id, i.e. "tutorial" or "0_diagnostic"
export(String) var Q_ID

# important nodes we'll need to reference, once we're in the scene
var utils

var quest_root

# todo: see if this can be removed now
var branch_group

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
export(String) var init_at
export(String) var complete_at

# logs/journals also come from the data file
# we preload the Branch class to use as a template later
var logs
var log_base
var Branch = preload("res://active-partials/quest-mgmt/quest_branch.gd")

var MUI
var popups
var dialog_label


# various boolean conditions this quest can be checked for
var branches_ready = false
var is_ready       = false setget ,is_ready
var is_active      = false setget ,is_active
var is_complete    = false

# event-based signals we can hook into later
signal branches_added(quest_id, actors)
signal branches_removed(quest_id, actors)
signal state_changed(quest_id, old_state, new_state)
signal quest_completed(quest_id, end_at)



func _init():
	branch_group = "" + str(Q_ID) + "-branches"



func load_data(data_source):
	data = utils.get_json(data_source)
	for key in data:
		self[key] = data[key]
		
	is_ready = true



# apply data from our parsed json to the Branch template
# and add the resulting branch node to the scene as children
func create_branches_from_data(data=data):
	for branch in branches:

		var branch_node = Branch.new()

		# branches can control their labels in the MUI individually,
		# or they can fall back to a quest-level default for it
		if( ! branch.has("dialog_label") ):
			branch_node.set("dialog_label", dialog_label)
		else:
			branch_node.set("dialog_label", branch.dialog_label)
			
			
		for key in branch:
			branch_node.set(key, branch[key])

		branch_node.set_name(Q_ID + "-" + branch["actor"])
		add_child(branch_node)
		branch_node.add_to_group(branch_group)


				
func attach_branch(branch):
	var actor_ref = branch.get("actor")
	if not get_tree().get_root().find_node(actor_ref):
		return
	else:
		remove_child(branch)
		var actor = get_tree().get_root().find_node(actor_ref)
		branch.set("Q_ID", Q_ID)
		branch.set_name(Q_ID)
		branch.set("owned_by", self)
		branch.set("dialog_label", dialog_label)
		
		
		var actor_owned = actor.get_children()
		for child in actor_owned:
			if( child.get_name() == branch.get_name() ):
				return
			else:
				continue
		
		actor.add_child(branch)
		actor["dialog_branches"].append(branch)
		actor["has_branches"] = true
		if ( actors.find(actor.get_name()) == -1 ):
			actors.append(actor_ref)
			actor.add_to_group(Q_ID + "-actors")



# this will generally come right after the function above
# it takes the child branches of this quest node and moves them
# so they're children of their associated NPCs instead
func attach_branches():

	var branch_nodes = get_children()
	for branch in branch_nodes:
	
		# this is how we selectively ignore nodes that aren't branches
		if branch.has_method("_at_state"):
			attach_branch(branch)
		else:
			return
			
	branches_ready = true
	emit_signal("branches_added", Q_ID, actors)


# detaching branches will generally happen when a quest is done
# and possibly even when a quest ceases to involve a given npc
# this involves updating the npc associated with the branch.
func detach_branch(branch):
	var actor_ref = branch.get("actor")
	if not get_tree().get_root().find_node(actor_ref):
		return
	else:
		var actor =  get_tree().get_root().find_node(actor_ref)
		if( actor["dialog_branches"].find(branch) > -1 ):
			actor.get_node(Q_ID).queue_free()
			actor["dialog_branches"].erase(branch)
			actor.call("check_branches")


# detach all branches for a given quest
# this is probably going to get used much more than detach_branch alone
# and will be one of the typical callbacks of a quest upon completion
func detach_branches():
	var branch_nodes = get_tree().get_nodes_in_group(branch_group)
	for branch in branch_nodes:
		detach_branch(branch)
	emit_signal("branches_removed", Q_ID, actors)



func is_active():
	return is_active


func is_ready():
	return is_ready


func is_attached():
	return branches_ready


func activate(start_state=init_at):
	if( is_active() == true ):
		print("Quest ", Q_ID, " is already active.")
	else:
		self.add_to_group("active_quests")
		create_branches_from_data(data)
		attach_branches()
		is_active = true
		set_current_state(start_state)
		print("Activated quest ", Q_ID , " at state ", start_state, " with actors ", actors)


func deactivate():
		self.remove_from_group("active_quests")
		detach_branches()
		is_active = false



func destroy():
	deactivate()
	call_deferred("free")



func set_current_state(state):

	pre_state_change(current_state, state)
	prev_state = current_state
	current_state = state
	
	if( logs.has(state) ):
		var _log = logs[state]
		_log["entry_id"] = Q_ID
		if( state == complete_at ):
			print("quest complete, marking entry as such")
			log_base.update_journal(_log, true)
		else:	
			log_base.update_journal(_log, false)
		
		
	emit_signal("state_changed", Q_ID, prev_state, state)
	
	post_state_change(prev_state, state)
	show_popups(state)
	
	
	if( state == complete_at ):
		complete(complete_at)
	


# this is here to be overridden
func pre_state_change(old_state, new_state):
	pass

func post_state_change(old_state, new_state):
	pass


func show_popups(state_key):
	if( popups.size() < 1 ):
		return
		
	if( popups.has(state_key) ):
		MUI.flash_popup(popups[state_key])


func get_current_state():
	return current_state


func complete(complete_at="100"):
	deactivate()
	add_to_group("completed_quests")
	is_complete = true
	emit_signal("quest_completed", Q_ID, complete_at)


func refresh():
	# cache the state just in case
	var start_at = get_current_state()
	create_branches_from_data(data)
	attach_branches()


func _enter_tree():
	utils = get_node("/root/utils")
	quest_root = get_parent()

#	add_user_signal("branches_added", [Q_ID, actors])
#	add_user_signal("branches_removed", [Q_ID, actors])
#	add_user_signal("state_changed", [Q_ID, prev_state, current_state])
#	add_user_signal("quest_completed", [Q_ID, complete_at])


func _setup():
	if (data_source == null):
		print("Error; cannot initialize quest with no data!")
		return
	else:
		load_data(data_source)
		log_base = get_node("/root/scene/journal_ui")
		MUI = get_node("/root/scene/message-ui")
		quest_root = get_parent()


func _ready():
	_setup()


func _test():
	pass
	#activate()
