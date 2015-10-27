# MUI scene

extends Node

var dialog_box
var portrait_box
var portrait
var text_box
var response_box
var response_base

var popup
var popup_text


var is_active
#var is_in_dialogue
var has_responses
var current_actor
var current_dialogue_branch
var current_responses
var current_text

signal dialogue_opened
signal dialogue_closed
signal text_loaded
signal responses_loaded
signal response_chosen

const paths = {
	dbox = "dialog-box",
	pbox = "dialog-box/Panel/HBoxContainer/portraitBox",
	pimg = "dialog-box/Panel/HBoxContainer/portraitBox/portrait",
	tbox = "dialog-box/Panel/HBoxContainer/textBox/PanelContainer/RichTextLabel",
	rbox = "dialog-box/Panel/HBoxContainer/textBox/VBoxContainer",
	rbase = "res://active-partials/message-ui/response-button.xml",
	popup = "popup",
	popup_text ="popup/Label"
}

const ResponseBase = preload("res://active-partials/message-ui/response-button.xml")
var M


######## make_dialogue #########
func make_dialogue(dlg_text):
	if( dlg_text == null ):
		return
	var output = ""
	if( typeof(dlg_text) == 21 ):
		for i in range(dlg_text.size()):
			output = output + str(dlg_text[i])
	else:
		output = dlg_text
	text_box.append_bbcode(output)
	current_text = text_box.get_bbcode()
	emit_signal("text_loaded", current_text)

####### clear dialogue ########
func clear_dialogue():
	text_box.clear()
	current_text = null


func clear():
	text_box.clear()
	var i
	
	for child in get_node(paths.rbox).get_children():
		get_node(paths.rbox).remove_child(child)
	current_text = null
	current_responses = null


######## make_response ######### 
func make_response(text, actions):
	var new_button = ResponseBase.instance()
	new_button.set_text(text)
	
	if( actions.size() > 0  ):
		for i in range(actions.size()):
			var action = actions[i]
			new_button.connect('pressed', action['target'], action["fn"], action["args"]);
			
	new_button.add_to_group("responses")
	get_node(paths.rbox).add_child(new_button)
	new_button.raise()
	has_responses = true
	return new_button

######## make_formatted_response ######### 
func make_formatted_response(text, actions):
	var formatted_text = " > " + text;
	make_response(formatted_text, actions)


######## make_responses ######### 
func make_responses(source_array, format):
	for response in source_array:
		if( format == true ):
			make_formatted_response(response["text"], response["actions"])
		else:
			make_response(response["text"], response["actions"])
	has_responses = true
	current_responses = get_tree().get_nodes_in_group("responses")
	emit_signal("responses_loaded", current_responses)



####### shortcut setup of the default "leave" option
func make_close_button():
	var _text = "<Leave.>"
	var	_actions = [{
			fn = "close",
			target = self,
			args = []
		}]
	make_response(_text, _actions)


####### setup character ########

func make_portrait(npc_texture):
	portrait.set("texture", npc_texture)

func make_formatted_name(npc_name):
	return "[b]" + str(npc_name).to_lower() + "> [/b]"

####### open/close ########

func open():
	dialog_box.popup()
	is_active = true;
	emit_signal("dialogue_opened")

func close():
	dialog_box.hide()
	is_active = false;
	emit_signal("dialogue_closed")



func flash_popup(text=""):
	popup_text.set_text(text)
	get_node("popup").show_modal(false)
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	yield(t, "timeout")
	get_node("popup").hide()



######## path setup ##########
func init_paths():
	dialog_box = get_node(paths.dbox)
	text_box = get_node(paths.tbox)
	portrait = get_node(paths.pimg)
	popup = get_node(paths.popup)
	popup_text = get_node(paths.popup_text)
	#M = get_node("/root/mocks").MUI.new()


###### other setup

func enter_tree():
	add_user_signal("text_loaded", ["text"])
	add_user_signal("responses_loaded", ["responses"])
	add_user_signal("dialogue_opened")
	add_user_signal("dialogue_closed")


######## _ready ######### 
func _ready():
	#get_node("/root/scene").set("MUI", get_node("."))
	#get_node("/root/game").set("MUI", get_node("."))
	get_node("/root/paths").set("MUI", get_path())
	init_paths()
	close()
	#demo()
	
	
######## demo ######### 	
func demo():
	make_dialogue(make_formatted_name("MPowell"))
	make_dialogue(M["dialogue_array"])
	make_responses(M["response_array"], false)