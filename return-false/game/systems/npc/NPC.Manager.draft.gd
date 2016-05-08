## NPC Manager node
# Should eventually exist in the main scene root,
# but can also live (as it does now in sandbox scenes) under an _Environment.
# Handles creating and updating NPCs, and communicating with quests.
extends Node

var npcs = {}
var npc_keys = []
var margin = 100
onready var container = get_node("HBoxContainer")
onready var npc_container = get_parent().get_node("environment/nav/walls")

const npc_base = preload("res://systems/npc/_NPC.draft.tscn")

signal QM_update_npcs




func _ready():
	_test()
	pass

## Add npc (STUB)
# currently just creates a copy from template and names it;
# in the long run, this should probably take a scene filepath as a param
# and instance from that.
func _add_npc(name):
	var new_npc = npc_base.instance()
	npc_container.add_child(new_npc)
	new_npc.set_pos(Vector2(margin, 120))
	new_npc.set_name(name)
	new_npc.add_to_group('npcs')
	
	npcs[new_npc.get_name()] = new_npc
	npc_keys.append(new_npc.get_name())
	
	margin = margin + 100
	
	emit_signal("QM_update_npcs")
	


func get_npcs():
	return npcs

func get_npc_keys():
	return npc_keys


func _test():
	
	_add_npc("abbot")
	_add_npc("costello")

	var wait = Timer.new()
	wait.set_wait_time(1.0)
	wait.set_one_shot(true)
	add_child(wait)
	wait.start()
	yield(wait, "timeout")
	_add_npc("godot")

	var wait2 = Timer.new()
	wait2.set_wait_time(3.0)
	wait2.set_one_shot(true)
	add_child(wait2)
	wait2.start()
	yield(wait2, "timeout")
	_add_npc("carlin")
