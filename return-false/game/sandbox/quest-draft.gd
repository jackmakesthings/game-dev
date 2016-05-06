## Quest base class
# Designed to be initialized with data (ie via Utils.get_json)
# and instanced via the Quest Manager node (which should always be in-scene)
extends Node
export(String) var key

# actors = npcs involved in this quest; NPCS = all npcs in the scene
var actors 
var NPCS

var previous_state
var current_state setget set_current_state

signal state_changed(to, from)

func _init(data):
	for prop in data:
		self[prop] = data[prop]
	set_name(self.key)
	

func _find_actors():
	for actor in self.actors:
		_find_actor(actor)

		
func _find_actor(actor):
	NPCS = get_tree().get_current_scene().find_node("NPCManager").npcs
	
	if !NPCS.has(actor):
		Utils.debug("can't find node " + actor)
		return
	else:
		var _actor_node = NPCS[actor]
		if _actor_node.is_in_group("actors_" + self.key):
			Utils.debug("actor " + actor + " is already accounted for")
			return
		
		else:
			_actor_node.add_to_group("actors_" + self.key)
			_actor_node.dialog_branches.append({"dialog_label": self.key, "active": true})
	
							
func set_current_state(value):
	previous_state = current_state
	current_state = value
	emit_signal("state_changed", current_state, previous_state)
	Utils.debug("state changed from "+ str(previous_state) + " to " + str(current_state))
	
													
func _ready():
	if is_inside_tree():
		_find_actors()
