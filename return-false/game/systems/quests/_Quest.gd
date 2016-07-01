## Quest base class
# Designed to be initialized with data (ie via Utils.get_json)
# and instanced via the Quest Manager node (which should always be in-scene)
extends Node
export(String) var key

# actors = npcs involved in this quest; NPCS = all npcs in the scene
var actors = {}
var NPCS

var logs
var popups
var dialog_label
var init_at

var flags

var previous_state
var current_state = "0" setget set_current_state,get_current_state
var Branch = preload('res://systems/quests/_Quest.Branch.gd')

signal state_changed(to, from)

func _init(data):
	for prop in data:
		self[prop] = data[prop]
	set_name(self.key)


func _create_branch(actor_name, actor_node):
	var _branch = Branch.new(self.actors[actor_name])
	_branch.parent_quest = self.key
	actor_node.add_child(_branch)
	actor_node.dialog_branches.append(_branch)

func _find_actors():
	for actor_name in self.actors.keys():
		_find_actor(actor_name)

		
func _find_actor(actor_name):
	NPCS = get_tree().get_current_scene().NPCManager.npcs
	
	if !NPCS.has(actor_name):
		return
	else:
		var _actor_node = NPCS[actor_name]
		if _actor_node.is_in_group("actors_" + self.key):
			return
		else:
			_actor_node.add_to_group("actors_" + self.key)
			_create_branch(actor_name, _actor_node)

							
func set_current_state(value):
	previous_state = current_state
	current_state = value
	emit_signal("state_changed", self.key, current_state, previous_state)

func get_current_state():
	return current_state	

func set_flag(flag, value):
	print("setting ", flag, " to ", value)
	self.flags[flag] = value													

func get_flag(flag):
	return self.flags[flag]
																																																																													
func _ready():
	if is_inside_tree():
		_find_actors()
