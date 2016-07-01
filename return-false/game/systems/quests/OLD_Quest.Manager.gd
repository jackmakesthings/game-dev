# currently on the quests (managing) node, needs some refactoring

extends Node

var quests = []
var active_quests
var quests_ready = false

const Quest = preload("res://active-partials/quest-mgmt/quest.gd")

signal quests_loaded

func get_state(quest, state):
	if not ( has_node(quest) ):
		print("Error - no such quest to update")
		return null
	return get_node(quest).current_state

func set_state(quest, state):
	get_node(quest).set_current_state(state)
	

func _quests_ready():
	var ret = false
	for quest in quests:
		if( ! quest.has_method("is_attached") ):
			return false
		if( quest.is_attached() == true ):
			continue
		else:
			return false
	return true


func _fixed_process(delta):
	if( quests_ready == false ):
		if( _quests_ready() == true ):
			emit_signal("quests_loaded")
			quests_ready = true

func _ready():

	var diag = get_node("0_diagnostic")
	diag.activate("0")
	
	quests = get_children()
	set_fixed_process(true)


