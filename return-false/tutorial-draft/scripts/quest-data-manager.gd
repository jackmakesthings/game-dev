extends Control

var utils

var questFile
var questData

var questStates
var currentState

var actor

func set_actor(actor):
	self.actor = actor

func get_actor():
	return self.actor

func set_quest_states(questData):
	questStates = []
	for s in questData:
		questStates.append(s)
	return questStates

func get_quest_states():
	return self.questStates

func set_current_state(stateID):
	self.currentState = questStates[stateID]

func get_current_state():
	return self.currentState

func get_quest_data(questFile):
	questData = utils.get_json(questFile)
	return questData

func get_responses(stateID, actor):
	var responses = []
	var stateData = questData[actor][stateID]
	if( ! stateData ):
		return []
	var responseData = stateData["options"]
	for r in responseData:
		responses.append(r)
	return responses

func get_dialogue(stateID, actor):
	var dialogue = ""
	if( questData[stateID]["dialogue"] ):
		dialogue = questData[stateID]["dialogue"]
	return dialogue

func _ready():
	pass

