###### base game script - scripts/game.gd
# save, load, quit, all the really really global data stuff
# autoloaded as /root/game

extends Node

var savepath = "res://savegame.txt"
var utils = preload("res://scripts/utils.gd").new()


var q

export var quests = Array()
export var quest_states = {
	1 : 0,
	2 : 0, 
	3 : 0,
	4 : 0,
	5 : 0
}

func get_quests():
	return quest_states.keys()

func get_quest_states():
	return quest_states

func get_state(quest):
	if( quest_exists(quest) ):
		return quest_states[quest]
	else:
		print("ERROR: Quest ", quest, " does not exist.")
		return -1


func quest_exists(key):
	if( quest_states.has(key) ):
		return true
	else:
		return false


func is_quest_active(key):
	q = get_quest_states()
	if not ( q.has(key) ):
		return false
	elif q.has(key) and q[key] == 0:
		return false
	elif q.has(key) and q[key] == 100:
		return false
	else:
		return true


func is_quest_completed(key):
	q = get_quest_states()
	if( q.has(key) and q["key"] == 100 ):
		return true
	else:
		return false


func add_quest(key, start=0):
	q = get_quests()
	if( q.find(key) > -1 ):
		print("ERROR: Quest key ", key, " is already in use!")
		return false
	else:
		quest_states[key] = start
		print("Added quest ", key, " at state ", start)
		emit_signal("quest_added", key, start)
		return true


func update_quest(key, state):
	if quest_exists(key) == false:
		print("ERROR: No quest ", key, " to update!")
		return false
	else:
		quest_states[key] == state
		print("Quest ", key, " is now at state ", state)
		return true


### note: this may not ever be used or needed, we'll see
func remove_quest(key, end=null):
	q = get_quests()
	if( q.find(key) < 0 ):
		print("ERROR: No quest ", key, " to remove!")
		return false
	else:
		if ( end ) and not ( end == null ):
			update_quest(key, end)
		quest_states.erase(key)
		emit_signal("quest_removed", key)
		print("Removed quest ", key)
		return true
		