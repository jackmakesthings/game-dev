# generic class for dialog branches
# dialog-branch-object.gd
# base class for individual branches of dialog
# branch = one actor's lines for one quest

extends Node

var data
var utils
export(String, FILE) var file = "res://needs-review/dynamic-node-tests/data.txt"
var states = {}
var currentState
var qNode
var qKey

func _enter_tree():
	utils = get_node("/root/utils")
	data = utils.get_json(file)
	qNode = get_parent().get_parent()
	qKey  = qNode.get_name()
	
	print(qKey)
	print("hello i am ", get_name(), " and my grandparent is ", get_parent().get_parent().get_name());
	
	if qNode extends(Area2D):
		self.add_to_group(qKey + "_branches")
	
	for state in data:
		printt(state)
		states[state] = state

func data_at_state(state):
	return data[state]
	
func text_at_state(state):
	return data[state]["text"]

func options_at_state(state):
	return data[state]["responses"]
