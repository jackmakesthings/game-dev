
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

export(String, FILE) var file = "res://assets/npc-data-example.gd"
var data 
var textbox
var buttonbox

var player

var trigger_button
var scenes
export var buttonLabel = ""
var quest
var quest_data
var quest_states
var message_ui = preload("res://scenes/message-ui.scn").instance()

var is_active_npc = false setget set_as_active_npc,is_active_npc

var is_internal_state = false

signal activated_npc(npc)

func set_as_active_npc(boolean):
	emit_signal("activated_npc", self)
	is_active_npc = boolean
	if( boolean == true ):
		message_ui.set_active_npc(self)
	else:
		message_ui.set_active_npc(null)
		
		
func is_active_npc():
	return is_active_npc
	
func get_data():
	data = get_node("/root/utils").get_json(file)
	return data
	
func set_state(stateID):
	quest.set_current_state(stateID)
	#return stateID

func get_quest_data(quest):
	var questkey = quest.get_key()
	data = get_data()
	quest_data = data["quests"][questkey]
	quest_states = quest_data["states"]
	
func get_dialogue_at_state(stateID):
	if( !is_active_npc ):
		set_as_active_npc(true)
	message_ui.set_active_npc(self)
	var dialogue=""
	get_quest_data(quest)
	
	if( quest_states.size() > 0 ):
		if ( quest_states[stateID]["dialogue"].length() > 0 ):
			dialogue = quest_states[stateID]["dialogue"]
			return dialogue
			
func get_responses_at_state(stateID):
	is_active_npc = true
	message_ui.set_active_npc(self)
	var responses = []
	var stateData = quest_states[stateID]
	if( stateData.size() < 1 ):
		return
	responses = stateData["options"]
	return responses
	
func is_internal_at_state(stateID):
	var stateData = quest_states[stateID]
	if( stateData.size() < 1 ):
		return false
	if( stateData["internal"] ):
		return true
	return false

func show_dialogue(stateID):
	message_ui.set("visibility/visible", true)
	var dialogue = get_dialogue_at_state(stateID)
	if( dialogue.length() > 0 ):
		message_ui.show_dialogue(dialogue)

func show_responses(stateID):
	var responses = get_responses_at_state(stateID)
	message_ui.show_responses_from_array(responses)

func goto_state(stateID):
	quest.set_current_state(stateID)
	message_ui.goto_state(stateID)
	#disable_new_interactions()
	
func disable_interaction():
	trigger_button.set("disabled", true)
	set_as_active_npc(true)
	
func enable_interaction():
	trigger_button.set("disabled", false)
	set_as_active_npc(false)

func init_at_current_state(npc):
	var stateID = quest.get_current_state()
	yield(player, "done_moving")
	#if( npc.get_child(0).is_pressed() ):
	message_ui.close()
	message_ui.set_active_npc(npc)
	message_ui.goto_state(stateID)
	
	


func _ready():
	message_ui = get_node("/root/game").get_node("message_ui")
	textbox = message_ui.get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/RichTextLabel")
	buttonbox = message_ui.get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/VBoxContainer")
	#trigger_button = get_node("./Control/Button")
	trigger_button = get_node("./TextureButton")
	player = get_node("/root/game/Navigation2D/YSort/robot")
	quest = get_node("/root/game/quest")
	data = get_data()
	scenes = get_parent().get_children()
	quest.set_current_state("20")
	trigger_button.add_to_group("npc_buttons")
	trigger_button.set_name(buttonLabel)
	self.trigger_button.connect("pressed", self, "init_at_current_state", [self])
	
	message_ui.close()
	pass


