# self-parsing quest branch template

extends Node

var Q_ID
var owned_by
var states

var paths
var game_root
var scene_root
var MUI

var actor

func _at_state(state):
	var state_obj = states[state]
	return state_obj

func text_at_state(state):
	if _at_state(state).has("dialogue"):
		return _at_state(state)["dialogue"]
	return null

func responses_at_state(state):
	if _at_state(state).has("responses"):
		return _at_state(state)["responses"]


# expects a json-based condition object
# with owner, param, compare, and val
func validate(c, context=self):
	#if( not c["owner"].is_inside_tree() ):
	#	return
	var method = c["compare"]
	var node = c["owner"]

	if( c["owner"] == "self" ):
		node = context
	else:
		node = get_tree().get_root().get_node(c["owner"])

	var param = node.get(c["param"])
	var val = c["val"]

	if( method == "equals" ):
		if( param == val ):
			return true
		return false
	elif( method  == "gt" ):
		if( param > val ):
			return true
		return false
	elif( method == "lt" ):
		if( param < val ):
			return true
		return false
	elif( method == "bool" ):
		return param
	else:
		return false
	return false


func build_response(response_data):
	var r = response_data
	var btn = MUI.make_response( r["text"], [])
	var fn = ""
	var arg = null

	if( r["new_state"] ):
		if( r["dialog_action"] == 0 ):
			fn = "update_and_close"
			arg = r["new_state"]
		elif( r["dialog_action"] == 1 ):
			fn = "update_and_continue"
			arg = r["new_state"]
	else:
		if( r["dialog_action"] == 0 ):
			fn = "end_dialog"
			arg = null
		elif( r["dialog_action"] == 1 ):
			fn = "continue_dialog"
			arg = null

	if not ( fn == "" ):
		btn.connect("pressed", self, fn, arg)

	if( r.has("conditions") ):
		for condition in r["conditions"]:
			if( validate(condition, self) == false ):
				btn.disconnect("pressed", self, fn)
				continue
			else:
				continue


func update_and_close(new_state):
	owned_by.set_current_state(new_state)
	MUI.close()


func update_and_continue(new_state):
	MUI.clear()
	owned_by.set_current_state(new_state)
	MUI.make_dialogue(text_at_state(new_state))
	for r in responses_at_state(new_state):
		build_response(r)

func end_dialog(params=null):
	MUI.close()

func continue_dialog(params=null):
	pass



	#	btn.connect("pressed", owned_by, "set_current_state", r["new_state"])
#
#	if( r["dialog_action"] == 1 ):
#		btn.connect("released", self, "continue_dialog_at", )

func _ready():
	paths = get_node("/root/paths")
	game_root = get_node("/root")
	scene_root = get_node("/root/scene")
	
	MUI = get_node("/root/scene/message-ui")
	owned_by = get_owner()

		