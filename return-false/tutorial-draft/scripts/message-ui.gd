
extends CanvasLayer

# member variables here, example:
# var a=2
# var b="textvar"

var dialog_box
var portrait_box
var portrait
var text_box
var response_box
var response_base

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
	rbase = "res://active-partials/message-ui/response-button.xml"
}

const ResponseBase = preload("res://active-partials/message-ui/response-button.xml")


######## make_response ######### 
func make_response(text, actions):
	var new_button = ResponseBase.instance()
	new_button.set_text(text)
	
	if( actions.size() > 0  ):
		for i in range(actions.size()):
			var action = actions[i]
			new_button.connect('pressed', action["target"], action["fn"], action["args"]);
			
	new_button.add_to_group("responses")
	get_node(paths.rbox).add_child(new_button)
	new_button.raise()


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


####### open/close ########

func open():
	is_active = true;
	emit_signal("dialogue_opened")

func close():
	is_active = false;
	emit_signal("dialogue_closed")


######## path setup ##########
func init_paths():
	text_box = get_node(paths.tbox)


######## _ready ######### 
func _ready():
	init_paths()
	demo()
	
	
######## demo ######### 	
func demo():

	var demoActions = [
		{
		fn = "do_the_thing",
		target = self,
		args = [20]
		},
		{
		fn = "do_the_other_thing",
		target = self,
		args = [30]
		}
	]
	
	var goTo10 = {}
	var setFlag40 = {}
	
	goTo10["fn"] = "do_the_thing"
	goTo10["target"] = self
	goTo10["args"] = [10]
	
	setFlag40["fn"] = "do_the_other_thing"
	setFlag40["target"] = self
	setFlag40["args"] = [40]

	var demoResponses = [
		{
			text = "I am certain they can.",
			actions = demoActions
		},
		{
			text = "<OVERRIDE> That is ridiculous. Robots never lie.",
			actions = [ goTo10, setFlag40 ]
		},
		{
			text = "<OVERRIDE> Maybe, but you can trust me.",
			actions = []
		}
	]
	
	text_box.append_bbcode("[color=#ffaa33]~gpowell:>[/color] Hey, Tr4ce, I've been thinking. \n")
	text_box.append_bbcode("[color=#ffaa33]~gpowell:>[/color] Do you think robots could ever be...dishonest? \n")
	text_box.append_bbcode("\n [color=#00ccdd]~ztr4ce.1.7.2:>_[/color]")
	#text_box.set_scroll_active(true)
	
	#print("is_scroll_active?", text_box.is_scroll_active())
	#print("is scroll following? ", text_box.is_scroll_following())
	#print(text_box.get_v_scroll())
	make_responses(demoResponses, false)
	
	
######## temp ######### 	
func do_the_thing(thing):
	print("Doing thing ", str(thing))
	
######## temp ######### 	
func do_the_other_thing(thing):
	print("let's also do ", str(thing))