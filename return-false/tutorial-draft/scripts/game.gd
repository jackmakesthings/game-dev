###### base game script - scripts/game.gd
# save, load, quit, all the really really global data stuff
# autoloaded as /root/game

extends Node

var savepath = "res://savegame.txt"
var utils = preload("res://scripts/utils.gd").new()


var q

var quests = [] setget ,get_quests
var quest_states = {} setget ,get_quest_states

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

func set_all_states(to="20"):
	for quest in quests:
		quest_states[quest] = to

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


#func add_quest(key, start=0):
#	q = get_quests()
#	if( q.find(key) > -1 ):
#		print("ERROR: Quest key ", key, " is already in use!")
#		return false
#	else:
#		quest_states[key] = start
#		print("Added quest ", key, " at state ", start)
#		emit_signal("quest_added", key, start)
#		return true


func update_quest(key, state):
	if quest_exists(key) == false:
		print("ERROR: No quest ", key, " to update!")
		return false
	else:
		quest_states[key] == state
		get_node("/root/scene/quests").set_state(key, state)
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

func _ready():
	var quest_holder
	if( get_tree().get_root().has_node("/root/scene/quests")):
		quest_holder = get_tree().get_root().get_node("/root/scene/quests")
	else:
		quest_holder = null
		
	if( quest_holder != null ):
		yield(quest_holder, "quests_loaded")
		for child in quest_holder.get_children():
			quest_states[child.get_name()] = child.get_current_state()
	
	#print(quest_states)
		