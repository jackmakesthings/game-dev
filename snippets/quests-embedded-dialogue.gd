# quest class
extends Control

export var file = "res://assets/dialogue-tree-json.txt"
export var buttonLabel = ""
# var quest
var data
var textbox
var buttonbox
var trigger_button
var scenes
var currentState

var d = "dialogue"
var r = "options"

func get_data():
	data = get_node("/root/utils").get_json(file)
	return data
	
func set_state(stateID):
	quest.currentState = stateID
	return stateID

func get_state():
	return currentState
		
func load_dialogue(npc_data):
	var dialogue = ""
	if( npc_data[d] ):
		dialogue = npc_data[d]
	return dialogue

func load_response_array(npc_data):
	var responses = []
	if ( npc_data.exists ):
		if ( npc_data[r].size() > 0 ):
			responses = npc_data[r]
	return responses

func goto_state(stateID):
	set_state(stateID)
	show_dialogue(stateID)
	show_responses(stateID)
	disable_new_interactions()

#########
close_dialogue()
close_all_dialogues()
disable_interaction()
enable_interaction()
enable_new_interactions()
disable_new_interactions()

	



			
func init_at_current_state():
	dialog.close_all_dialogues()
	goto_state(get_state())


func _ready():
	textbox = get_node("./Control/VBoxContainer/RichTextLabel")
	buttonbox = get_node("./Control/VBoxContainer/ButtonGroup")
	trigger_button = get_node("./Control/Button")
	data = get_data()
	scenes = get_parent().get_children()
	
	trigger_button.set_text(buttonLabel)
	trigger_button.connect("pressed", self, "init_at_current_state")


