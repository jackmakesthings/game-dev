#npc class

extends Node

var label = "Terminal"
var quests # instances, probably
var source_file = "res://assets/dialogue/terminal.gd"
var source_data

var dialog_ui # instance

var is_interacting = false
var can_interact = true
var using_full_dialogs = true

var quest # active quest, as reference maybe

var line
var options

var quest_state

func update_data():
	quest_state = quest.get_state()
	source_data = quest.get_npc_data(self, quest, quest_state)

func start_interacting():

	if( ! can_interact ):
		return

	quest.get_data(source_file)
	update_data()
	set_dialogue()
	set_responses()
	is_interacting = true

func set_dialogue():
	update_data()
	line = quest.load_dialogue(source_data)
	dialog_ui.show_dialogue(line)

func set_responses():
	update_data()
	options = quest.load_response_array(source_data)
	dialog_ui.show_responses(options)

func stop_interacting():
	dialog_ui.close_dialogue()
	is_interacting = false
