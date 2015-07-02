
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

var terminalLabel
var cabinetLabel
var engineerLabel

var engineer
var cabinet
var terminal

var npcClass = preload("res://scripts/interactable.gd")

func update_labels():
	var fsm = get_node("basic-diagnostics")

	terminal.set_active_dialog(fsm.terminal.dialog)
	terminal.set_responses(fsm.terminal.options)
	
	cabinet.set_active_dialog(fsm.cabinet.dialog)
	cabinet.set_responses(fsm.cabinet.options)
	
	engineer.set_active_dialog(fsm.engineer.dialog)
	engineer.set_responses(fsm.engineer.options)
	
	
func make_npc(name, parent, group):
	
	var npc = npcClass.new()
	npc.set_name(name)
	if( group ):
		npc.add_to_group(group)
	parent.add_child(npc)
	npc.raise()
	return npc

func _ready():
	var c = get_node("Control")
	terminalLabel = c.get_node("terminalLabel")
	engineerLabel = c.get_node("engineerLabel")
	cabinetLabel = c.get_node("cabinetLabel")
	
	var n = get_node("nodes")
	terminal = make_npc("terminal", n, "npcs")
	engineer = make_npc("engineer", n, "npcs")
	cabinet = make_npc("cabinet", n, "npcs")
		
	# Initialization here
	pass