
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var textbox = RichTextLabel.new()
var buttonbox = VBoxContainer.new()
var namebox = Label.new()

var dialogue =""
var response_array = []

var is_active = false

var quest
var active_quest

var npc
var npcs
var active_npc setget set_active_npc,get_active_npc

const pace = 3
var text_length
var i = 0

var move_player

signal npc_activated
signal npc_checked

signal opened
signal closed

#typewriter effect ################
#func _fixed_process(delta):
#	if ( textbox.get_visible_characters() > textbox.get_total_character_count() ):
#		set_fixed_process(false)
#		for i in buttonbox.get_children():
#			i.set_opacity(1.0)
		
#	if( i == pace ):
#		textbox.set_visible_characters( textbox.get_visible_characters() + 1 )
#		i = 0
#	else:
#		i = i+1
#	pass

func remove_buttons():
	var responses = get_tree().get_nodes_in_group("dialogue_responses")
	for response in responses:
		response.queue_free()
	response_array = []
	#var kids = buttonbox.get_children()
	#for kid in kids:
	#	buttonbox.remove_child(kid)

func set_active_npc(npc):
	if ( npc != active_npc ):
		emit_signal("npc_activated", npc)
		active_npc = npc

func set_active_quest(quest):
	active_quest = quest
	print("Active quest is now ", quest)

func get_active_npc():
	emit_signal("npc_checked", active_npc)
	return active_npc
	
func announce_npc_active(npc):
	print("Active NPC:" + npc.buttonLabel)

func show_dialogue(dialogue_string):
	textbox.clear()
	textbox.add_text(dialogue_string)
	move_player = false

func show_dialogue_from_quest(stateID):
	textbox.clear()
	dialogue = active_npc.get_dialogue_at_state(stateID)
	namebox.set_text(active_npc.buttonLabel + ":")
	is_active = true
	self.set("visibility/visible", true)
	show_dialogue(dialogue)
	
func show_responses_from_quest(stateID):
	is_active = true
	remove_buttons()
	response_array = active_npc.get_responses_at_state(stateID)
	show_responses_from_array(response_array)
	
func enable_interactions():
	for n in npcs:
		if( n.is_type("TextureButton") ):
			n.set("disabled", false)

func disable_interactions():
	move_player = false
	for n in npcs:
		if( n.get_parent() == active_npc ):
			continue
		if( n.is_type("TextureButton") ):
			n.set("disabled", true)

func open():
	is_active = true
	remove_buttons()
	namebox.set_text(active_npc.buttonLabel + ":")
	self.set("visibility/visible", true)
	self.raise()
	move_player = false
	emit_signal("opened", active_npc)

func close():
	is_active = false
	remove_buttons()
	self.set("visibility/visible", false)
	move_player = true
	emit_signal("closed")

func make_actions_from_data(response):
	var actions = []
	for action in response["actions"]:
		var fref = {}
		fref.f = action["func"]
		if( action.params.size() > 0 ):
			fref.p = action.params
		else:
			fref.p = []
		#print(fref)
		actions.append(fref)
	return actions

func make_response_button(r):
	var rbtn = Button.new()
	var txt = r["text"]
	var action = r["action"]
	#var stateID = quest.get_current_state()
	#var endState = r["endState"]
	var actions = []
	if( r.has("actions") ):
		actions = make_actions_from_data(r)
	
	rbtn.set_name(txt)
	rbtn.set_text(txt)
	rbtn.set_text_align(0)
	rbtn.set_h_size_flags(3)		# will be refactored out when GUI system is built
	rbtn.set_v_size_flags(1)		# same
	rbtn.add_to_group("dialogue_responses")
	
	#rbtn.connect("pressed", self, "on_response_pressed", [str(action), str(stateID), str(endState)])
	
	for act in actions:
		rbtn.connect("pressed", self, act.f, act.p)
	return rbtn

func show_responses_from_array(option_array):
	response_array = []
	if ( option_array.size() > 0 ):
		response_array = option_array
		var i = 0
		for o in option_array:
			var rbtn = make_response_button(o)
			rbtn.set_text(str(i + 1) + ". " + rbtn.get_text())
			buttonbox.add_child(rbtn)
			rbtn.raise()
			i = i+1

func choose_response_by_key(key_choice):
	var response_buttons = get_tree().get_nodes_in_group("dialogue_responses")
	if( response_buttons.size() >= int(key_choice) and int(key_choice) > 0):
		response_buttons[int(key_choice) - 1].emit_signal("pressed")

func goto_state(stateID):
	is_active = true
	quest.set_current_state(stateID)
	show_dialogue_from_quest(stateID)
	show_responses_from_quest(stateID)
	disable_interactions()

func on_response_pressed(action, startState, endState):
	move_player = false
	quest.set_current_state(endState)
	if( action == "end_dialog" ):
		close()
		accept_event()
		enable_interactions()
	elif( action == "next_dialog" ):
		accept_event()
		goto_state(endState)
		

### newer, more abstract/dynamic function experiments

func set_quest_state(state, branch):
	quest.set_current_state(state)

func next_dialog(state, branch):
	accept_event()
	goto_state(state)

func end_dialog():
	close()
	accept_event()
	enable_interactions()
								
						
func _ready():
	textbox = get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/RichTextLabel")
	buttonbox = get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/VBoxContainer")
	namebox = get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/Label")
	quest = get_node("/root/game/quest")
	set_active_quest(quest)
	npcs = get_tree().get_nodes_in_group("npc_buttons")
	textbox.set_visible_characters(-1)
	
	connect("npc_activated", self, "announce_npc_active", [npc])

	text_length = textbox.get_total_character_count()
	
	move_player = true
	
	#set_fixed_process(true)

