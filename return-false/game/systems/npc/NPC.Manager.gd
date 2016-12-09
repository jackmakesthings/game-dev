## NPC Manager node
# Gets initialized right into the main game node
# Handles creating and updating NPCs, and communicating with quests.
extends Node

var npcs = {}
var npc_keys = []
var npc_container

const npc_base = preload("res://systems/npc/_NPC.tscn")

signal QM_update_npcs


## Add npc (STUB)
# currently just creates a copy from template and names it;
# in the long run, this should probably take a scene filepath as a param
# and instance from that.
func _add_npc(name):
	var new_npc = npc_base.instance()
	npc_container.add_child(new_npc)
	new_npc.set_name(name)
	new_npc.add_to_group('npcs')
	npcs[new_npc.get_name()] = new_npc
	npc_keys.append(new_npc.get_name())
	
	emit_signal("QM_update_npcs")

	
# Alternately, you can call this when adding a scene
# that already contains NPC nodes; this should parse them
# and add them to the npc registry, if they aren't there already.			
func _pull_npcs():
	for npc in npc_container.get_children():
		if ! npc.has_method('start_interaction'):
			return 
		if ! npcs.has(npc):
			npcs[npc.get_name()] = npc
			npc_keys.append(npc.get_name())
			
			if !npc.is_in_group('npcs'):
				npc.add_to_group('npcs')
				
	emit_signal("QM_update_npcs")			
		
func get_npcs():
	return npcs

func get_npc_keys():
	return npc_keys

func _ready():
	npc_container = Game.Object_Layer
	_pull_npcs()