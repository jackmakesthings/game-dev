
extends Node2D

var npcs
var quests
var ui_mode


# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	var npc = get_node("npc_container/npc")
	var npc2 = get_node("npc_container/npc 2")
	var quest = "tutorial"
	
	npc.set_active_quest(quest)
	npc.enable_interaction()
	npc.start_interaction(true)
	
	npc2.set_active_quest("states_without_dialogue")
	print(npc2.can_interact)
	npc2.get_data_at_state("20", "states_without_dialogue")
	npc2.start_interaction(false)


