
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var textbox = RichTextLabel.new()
var buttonbox = VBoxContainer.new()

var quest

const pace = 3
var text_length
var i = 0

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

func show_dialogue(dialogue_string):
	textbox.clear()
	textbox.add_text(dialogue_string)

func make_response_button(r):
	var rbtn = Button.new()
	var txt = r["text"]
	#var txt = r
	var action = r["action"]
	var stateID = quest.get_current_state()
	var endState = r["endState"]
	
	rbtn.set_name(txt)
	rbtn.set_text(txt)
	rbtn.set_text_align(0)
	rbtn.set_opacity(0.0)
	rbtn.set_h_size_flags(3)		# will be refactored out when GUI system is built
	rbtn.set_v_size_flags(1)		# same
	rbtn.connect("pressed", self, "on_response_pressed", [str(action), str(stateID), str(endState)])
	return rbtn
	
func _ready():
	textbox = get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/RichTextLabel")
	buttonbox = get_node("CenterContainer/HBoxContainer/MarginContainer1/ScrollContainer/VBoxContainer")
	quest = get_node("/root/game/quest")
	textbox.set_visible_characters(-1)
	
	#textbox.add_text("Hello!")
	#textbox.newline()
	#textbox.add_text("This box sure has some text in it. I bet if we made this text really long, the scrolling container bars would kick in. But I am not sure whether that would happen at the panel level or the text one. Hmm...")
	
	#var btn = make_response_button("1. Do the thing")
	#var btn2 = make_response_button("2. Don't do the thing")
	
	#buttonbox.add_child(btn)
	#buttonbox.add_child(btn2)
		
	
		# Initialization here
	text_length = textbox.get_total_character_count()
	
	#set_fixed_process(true)
	pass


