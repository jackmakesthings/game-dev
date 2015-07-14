# quest class, new data org

extends Node


# used elsewhere to reference this quest, must be unique
export var key = "quest-name" setget set_key, get_key
#export var key = "quest-name" setget set_key, get_key

# quests keep pointers to their current condition
export(int, 0, 100) var current_state = 0 setget set_current_state, get_current_state

# keep track of relevant npcs
var actors

# boolean - is the quest running?
export var is_active = false

signal quest_state_updated(quest, oldState, newState)


func set_key(new_key):
	key = new_key

func get_key():
	return key

func set_current_state(state_id):
	var oldState = get_current_state()
	print("NOTE: Quest '" + key + "' is now at state " + str(state_id))
	# notify members somehow here?
	current_state = state_id
	emit_signal("quest_state_updated", key, oldState, current_state )

func get_current_state():
	return current_state

func find_actors():
	var npcs = get_tree().get_nodes_in_group("npcs")
	for npc in npcs:
		var quest_data = npc.quests
		for quest in quest_data:
			if( quest["key"] == key ):
				actors.append(npc)
				return
	return actors

func set_actors(npcs):
	actors = npcs

func get_actors():
	return actors

func involves_actor(npc):
	if( actors.contains(npc) ):
		return true
	else:
	#	var quest_data = npc.quests
	#	for quest in quest_data:
	#		if( quest["key"] == key ):
	#			actors.append(npc)
	#			return true
		return false
	# return false

func add_actor(npc):
	actors.append(npc)
	return actors

func activate():
	is_active = true

func deactivate():
	is_active = false