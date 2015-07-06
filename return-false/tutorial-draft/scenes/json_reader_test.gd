
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var file = "res://assets/dialogue-tree-json.txt"
var data
var textbox
var buttonbox
var testbuttonbox
var reset_button
var scenes
# var currentState

func get_data():
	data = get_node("/root/utils").get_json(file)
	return data
	
func remove_children(node):
	#var nb = node.get_child_count() - 1
	var kids = node.get_children()
	for kid in kids:
		node.remove_child(kid)
	

func show_as_line(dataObject):
	textbox.newline()
	textbox.add_text(str(dataObject))
	textbox.newline()
	

func show_dialogues():
	var dialogues = []
	for i in data:
		dialogues.append(str(i) + ": " + data[i]["dialogue"])
	dialogues.sort()
	for i in dialogues:
		show_as_line(i)
		
func show_dialogue(stateID):
	var dialogue = ""
	if( data[stateID]["dialogue"] ):
		dialogue = data[stateID]["dialogue"]
	show_as_line(dialogue)

func show_responses(stateID):
	remove_children(buttonbox)
	var stateData = data[stateID]
	var responses = stateData["options"]
	if( responses.size() > 0 ):
		for r in responses:
			var rbtn = Button.new()
			var txt = r["text"]
			var action = r["action"]
			var endState = r["endState"]
			rbtn.set_name(txt)
			rbtn.set_text(txt)
			rbtn.set_h_size_flags(3)
			rbtn.set_v_size_flags(1)
			buttonbox.add_child(rbtn)
			rbtn.connect("pressed", self, "on_response_pressed", [str(action), str(stateID), str(endState)])
	else:
		remove_children(buttonbox)

func on_response_pressed(action, startState, endState):
	#textbox.clear()
	show_as_line(action + "( Goto: " + str(endState) + " )")
	Globals.currentState = endState
	highlight_current_state()
	textbox.clear()
	show_dialogue(str(endState))
	show_responses(str(endState))
	if( action == "end_dialog" ):
		close_all_dialogues()

func highlight_current_state():
	var allButtons = testbuttonbox.get_children()
	for i in allButtons:
		if( i extends Button ):
			i.set("flat", false)
	var currentButton = testbuttonbox.get_node(str(Globals.currentState))
	if( currentButton ):
		currentButton.set("flat", true)
	

func goto_state(stateID):
	remove_children(buttonbox)
	textbox.clear()
	Globals.currentState = stateID
	show_dialogue(stateID)
	show_responses(stateID)
	highlight_current_state()
	disable_all_interactions()

func make_test_buttons():
	var keys = data.keys()
	keys.sort()
	for s in keys:
		if( data[s]["internal"] ):
			continue
		var sbtn = Button.new()
		sbtn.set_name(str(s))
		sbtn.set_text(str(s))
		testbuttonbox.add_child(sbtn)
		sbtn.connect("pressed", self, "test_state", [str(s)])
	
func _reset_states():
	textbox.clear()
	remove_children(buttonbox)
	Globals.currentState = "20"
	show_dialogue("20")
	show_responses("20")
	highlight_current_state()

func close_dialogue():
	textbox.clear()
	remove_children(buttonbox)
	enable_all_interactions()
	
func disable_interaction():
	reset_button.set("disabled", true)
	
func enable_interaction():
	reset_button.set("disabled", false)
	
func enable_all_interactions():
	for s in scenes:
		if( s.has_method("enable_interaction")):
			s.enable_interaction()
	
func disable_all_interactions():
	for s in scenes:
		if( s.has_method("disable_interaction")):
			s.disable_interaction()

func close_all_dialogues():
	for s in scenes:
		if( s.has_method("close_dialogue")):
			s.close_dialogue()
			
func init_at_current_state():
	var stateID = Globals.currentState
	close_all_dialogues()
	goto_state(stateID)
	
func kickoff():
	data = get_data()
	show_dialogue("20")
	show_responses("20")
	make_test_buttons()
	highlight_current_state()

func _ready():
	textbox = get_node("./Control/VBoxContainer/RichTextLabel")
	buttonbox = get_node("./Control/VBoxContainer/ButtonGroup")
	testbuttonbox = get_node("./Control/VBoxContainer 2")
	reset_button = get_node("./Control/Button")
	data = get_data()
	scenes = get_parent().get_children()
	
	Globals.currentState = "20"
	
	
	
	reset_button.connect("pressed", self, "init_at_current_state")
	# reset_button.connect("pressed", self, "_reset_states")	
	# Initialization here
	pass


