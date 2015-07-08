
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

export var file = "res://assets/dialogue-tree-json.txt"
var data
var textbox
var buttonbox
#var testbuttonbox
var trigger_button
var scenes
export var buttonLabel = ""
# var currentState

func get_data():
	data = get_node("/root/utils").get_json(file)
	return data
	
func set_state(stateID):
	Globals.currentState = stateID
	return stateID
	
func remove_children(node):
	#var nb = node.get_child_count() - 1
	var kids = node.get_children()
	for kid in kids:
		node.remove_child(kid)
	

func show_as_line(dataObject):
	textbox.newline()
	textbox.add_text(str(dataObject))
	textbox.newline()
	

#func show_dialogues():
#	var dialogues = []
#	for i in data:
#		dialogues.append(str(i) + ": " + data[i]["dialogue"])
#	dialogues.sort()
#	for i in dialogues:
#		show_as_line(i)
		
func show_dialogue(stateID):
	var dialogue = ""
	if( data[stateID]["dialogue"] ):
		dialogue = data[stateID]["dialogue"]
	show_as_line(dialogue)

func make_response_button(r):
	var rbtn = Button.new()
	var txt = r["text"]
	var action = r["action"]
	var stateID = Globals.currentState
	var endState = r["endState"]
	
	rbtn.set_name(txt)
	rbtn.set_text(txt)
	rbtn.set_h_size_flags(3)		# will be refactored out when GUI system is built
	rbtn.set_v_size_flags(1)		# same
	rbtn.connect("pressed", self, "on_response_pressed", [str(action), str(stateID), str(endState)])
	return rbtn

func show_responses(stateID):
	remove_children(buttonbox)
	var stateData = data[stateID]
	if( stateData.size() < 1 ):
		remove_children(buttonbox)
		return
	var responses = stateData["options"]
	if( responses.size() > 0 ):
		for r in responses:
			var rbtn = make_response_button(r)
			buttonbox.add_child(rbtn)
	else:
		remove_children(buttonbox)

func on_response_pressed(action, startState, endState):
	set_state(endState)
	if( action == "end_dialog" ):
		close_all_dialogues()
	elif( action == "next_dialog" ):
		goto_state(endState)

#func highlight_current_state():
#	var allButtons = testbuttonbox.get_children()
#	for i in allButtons:
#		if( i extends Button ):
#			i.set("flat", false)
#	var currentButton = testbuttonbox.get_node(str(Globals.currentState))
#	if( currentButton ):
#		currentButton.set("flat", true)

func goto_state(stateID):
	close_dialogue()
	
	set_state(stateID)
	show_dialogue(stateID)
	show_responses(stateID)
	disable_new_interactions()
	# highlight_current_state()

#func make_test_buttons():
#	var keys = data.keys()
#	keys.sort()
#	for s in keys:
#			continue
#		var sbtn = Button.new()
#		sbtn.set_name(str(s))
#		sbtn.set_text(str(s))
#		testbuttonbox.add_child(sbtn)
#		sbtn.connect("pressed", self, "test_state", [str(s)])

func close_dialogue():
	textbox.clear()
	remove_children(buttonbox)
	enable_new_interactions()
	
func disable_interaction():
	trigger_button.set("disabled", true)
	
func enable_interaction():
	trigger_button.set("disabled", false)
	
func enable_new_interactions():
	for s in scenes:
		if( s.has_method("enable_interaction")):
			s.enable_interaction()
	
func disable_new_interactions():
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


func _ready():
	textbox = get_node("./Control/VBoxContainer/RichTextLabel")
	buttonbox = get_node("./Control/VBoxContainer/ButtonGroup")
	trigger_button = get_node("./Control/Button")
	data = get_data()
	scenes = get_parent().get_children()
	
	trigger_button.set_text(buttonLabel)
	trigger_button.connect("pressed", self, "init_at_current_state")
	pass


