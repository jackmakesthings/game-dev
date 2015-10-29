# self-parsing quest branch template

extends Node

var Q_ID
var owned_by # the node for the quest represented by Q_ID
var states

var paths
var game_root
var scene_root
var MUI

export(String) var dialog_label

# the npc to tie this branch to
var actor

# return all data for a given state
func _at_state(state):
	var state_obj = null
	if( states.has(state) ):
		state_obj = states[state]
	return state_obj

# return just the dialogue
func text_at_state(state):
	if _at_state(state) == null:
		return null
	if _at_state(state).has("dialogue"):
		return _at_state(state)["dialogue"]
	return null

# return just the response options
func responses_at_state(state):
	if _at_state(state) == null:
		return null
	if _at_state(state).has("responses"):
		return _at_state(state)["responses"]


# expects a json-based condition object
# with owner, param, compare, and val
# owner can be self, player, or a nodepath
# param is whatever stat we're checking for, val is the required value
# compare is the function to check with: exists, equals, lt, gt, bool
func validate(c):

	#print(c["owner"])
	var method = c["compare"]
	var node = c["owner"]

	if( c["owner"] == "self" ):
		node = get_parent()
	elif c["owner"] == "player":
		node = get_node("/root/scene").get("player")
	
	
	#print(node.get_name())
	var param = node.get(c["param"])
	var val = c["val"]
	var inv = ""

	# use one of these validations
	if( method == "exists" ):
		if (param == null):
			inv = "You must have " + c["param"] + " for this option."
	elif( method == "equals" ):
		if not( param == val ):
			inv = c["param"] + " must be equal to " + str(val)
	elif( method  == "gt" ):
		if not ( param > val ):
			inv = c["param"] + " must be greater than " + str(val)
	elif( method == "lt" ):
		if not ( param < val ):
			inv = c["param"] + " must be less than " + str(val)
	elif( method == "bool" ):
		if param == false:
			inv = c["param"] + " must be true"
	else:
		inv = ""
		
	
	if( inv == "" ): # it passed its checks, validate = true
		return true
	else: # something didn't pass! 
		print(inv)
		return false


func build_response(response_data):
	var r = response_data
	var btn = MUI.make_response( r["text"], []) # MUI builds the button, branch hooks it up
	var fn = ""
	var arg

	# if new state is set, update and either close or continue
	if r.has("new_state"):
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
		btn.connect("pressed", self, fn, [arg])

	# see if this option has pre-reqs, disable if they aren't met
	if( r.has("conditions") ):
		for condition in r["conditions"]:
			print( condition )
			if( validate(condition) == false ):
				print("invalid!")
				btn.disconnect("pressed", self, fn)
				btn.set("disabled", true)
	return btn


func update_and_close(new_state):
	owned_by.set_current_state(new_state)
	MUI.close()

func update_and_continue(new_state):
	owned_by.set_current_state(new_state)
	MUI.clear()
	# load up the interaction for the new state
	#MUI.make_dialogue(actor["label"])
	MUI.make_dialogue(text_at_state(new_state))
	for r in responses_at_state(new_state):
		build_response(r)

func end_dialog(params=null):
	print("Ending dialog")
	MUI.close()

# this will probably not be used ever
func continue_dialog(params=null):
	print("Continuing dialog")
	pass

func _ready():
	# todo: standardize path management
	paths = get_node("/root/paths")
	game_root = get_node("/root")
	scene_root = game_root.get_node("scene")
	MUI = scene_root.get_node("message-ui")
	
