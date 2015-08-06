# Note for the reader:
#
# This demo conveniently uses the same names for actions and for the container nodes
# that hold each remapping button. This allow to get back to the button based simply
# on the name of the corresponding action, but it might not be so simple in your project.
#
# A better approach for large-scale input remapping might be to do the connections between
# buttons and wait_for_input through the code, passing as arguments both the name of the
# action and the node, e.g.:
# button.connect("pressed", self, "wait_for_input", [ button, action ])

extends Control

var keys = { 1: "Hardware", 2: "Software", 3: "Both", 4: "Neither" }
var choices = []
var i = 1
var choice_picked = false


func _input(event):
	var choice
	var choice_selected
	
	if ( event.type == InputEvent.MOUSE_BUTTON ):
		print( event )
	if (event.type == InputEvent.KEY):
		# Register the event as handled and stop polling
		get_tree().set_input_as_handled()
		set_process_input(false)
		
		if( event.is_action("select_1")):
			choice = get_node("1")
		elif( event.is_action("select_2")):
			choice = get_node("2")
		elif( event.is_action("select_3")):
			choice = get_node("3")
		elif( event.is_action("select_4")):
			choice = get_node("4")
		
		if ( choice ):
			if( choices.size() > 0 and not choice_picked):
				for node in choices:
					node.hide()
				choice.show()
				choice_picked = true;
		
	#	if (not event.is_action("ui_cancel")):
		
	#		choice_selected = OS.get_scancode_string(event.scancode) 
			
	#		if ( choices.size() > 0 and not choice_picked):
	#		choice = get_node(choice_selected)
	#		if( choice ) :
	#			for node in choices:
	#				node.hide()
	#			choice.show()
	#			choice_picked = true

func errbody_got_choices():
	var nodes = get_root().get_children()
	for node in nodes:
		if ( node.is_in_group('choices')):
			choices.append(node)
	print(choices)
	pass



func start_choice():
	i = 1
	set_process_input(true)

func load_choices():
	i = 1
	var btn
	for key in keys:
		btn = Button.new()
		btn.name = "btn-" + i
		btn.text = str(i) + ":  " + keys[i]
		btn.size = (100,50)
		btn.add_to_group("choices")
		get_node(".").add_child(btn)
		#get_node(str(i)).text =  str(i) +  ": " + keys[i]
		i += 1
	errbody_got_choices()

func _ready():
	# Initialise each button with the default key binding from InputMap
	var input_event
	i = 1
	load_choices()
	start_choice()


func _on_button_pressed(index):
	get_node("init").hide()
	if( choices and choices[index] ):
		for node in choices:
			node.hide()
		choices[index].show()
	pass # replace with function body

func reset_choices():
	if( choices.size > 0 ):
		for node in choices:
			node.show()
