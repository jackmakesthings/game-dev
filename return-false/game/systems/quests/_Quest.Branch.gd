## Parsing and handling NPC dialogue branches
extends Node

var dialog_label
var parent_quest
var states
var QM
var MUI

func _init(data):
	for key in data:
		self[key] = data[key]

func _ready():
	QM = get_tree().get_current_scene().QuestManager
	MUI = get_tree().get_current_scene().MessageUI


func get_parent_state():
	QM = get_tree().get_current_scene().QuestManager
	var _quest = QM.get_quest(parent_quest)
	return _quest.current_state

func has_state(state_id):
	return (states.has(state_id) and states[state_id].has('dialogue') and states[state_id].has('responses'))

func has_active_state():
	var _active = get_parent_state()
	return has_state(_active)

func _at_state(state_id):
	if has_state(state_id):
		return states[state_id]

func text_at_state(state_id):
	if has_state(state_id) and _at_state(state_id).has('dialogue'):
		return _at_state(state_id).dialogue

func responses_at_state(state_id):
	if has_state(state_id) and _at_state(state_id).has('responses'):
		return _at_state(state_id).responses

func actions_at_state(state_id):
	if has_state(state_id) and _at_state(state_id).has('actions'):
		return _at_state(state_id).actions
	

## These methods are related to the response options
# generated by the MessageUI using this branch's data.
func build_response(data):
	var fn
	var arg = null
	var target = self
	var A = {}
	var all_actions = [A]

	if data.has('new_state'):
		A["args"] = [data.new_state]
		
		if data.dialog_action == 1:
			fn = 'update_and_continue'
		else:
			fn = 'update_and_close'

	else:
		fn = 'end_dialog'
		
	A["fn"] = fn
	A["target"] = target

	if data.has('actions'):
		for action in data.actions:
			all_actions.append(action)
		
	MUI.response({ "text": data.text, "actions": all_actions })


func update_and_close(new_state):
	QM.set_state(parent_quest, new_state)
	MUI.close()

func update_and_continue(new_state):
	QM.set_state(parent_quest, new_state)
	
	MUI.clear()
	MUI.say(text_at_state(new_state))
	for r in responses_at_state(new_state):
		if r == null:
			return
		else:
			build_response(r)

func end_dialog():
	MUI.close()
