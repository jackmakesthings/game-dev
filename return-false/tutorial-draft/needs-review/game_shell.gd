
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	var npc = get_node("npc_container/npc")
	npc._test("tutorial")
	npc._test("no_states")
	npc._test("empty_states")
	
	npc._test("fake")
	
	
	npc.get_data_at_state("20", "states_without_dialogue")
	# Initialization here
	pass


