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
var keys2 = { 1: "Desktops", 2: "Laptops", 3: "Tablets", 4: "Robots" }
var dialogPath = [ { 1: "Pie", 2: "Cake" }, { 1: "Apple", 2: "Pumpkin" }, { 1: "Angel food", 2: "No, like the band" } ]



var choices = []
var i = 1
var choice_picked = false
var current_choice

var dialogPath_pos = 0;


func _input(event):
	var choice = null
	var choice_selected
	
	if (event.type == InputEvent.KEY):
		# Register the event as handled and stop polling
		#get_tree().set_input_as_handled()
		set_process_input(false)
		
		if( event.is_action("select_1")):
			choice = 1
		elif( event.is_action("select_2")):
			choice = 2
		elif( event.is_action("select_3")):
			choice = 3
		elif( event.is_action("select_4")):
			choice = 4
		elif( event.is_action("reset")):
			reset_path()
		
		#if ( is_dialogPath_finished() ):
		#	get_tree().call_group(0, 'choices', 'queue_free')
		#	get_node("Label").set_text("I should go.")
			
			
		if ( not is_dialogPath_finished() and choice ):
			make_choice( choice )
		
		if ( is_dialogPath_finished() ):
			set_process_input(false)
			get_node("Label").set_text("I should go.")
			#make_choice( choice )
		#if ( is_dialogPath_finished() ):
			
				

func errbody_got_choices():
	choices =  get_tree().get_nodes_in_group('choices')



func start_choice():
	i = 1
	set_process_input(true)

func load_choices(keys):
	
	i = 1
	var btn
	for key in keys:
		btn = Button.new()
		btn.set_name("btn-" + str(i))
		btn.text = str(i) + ":  " + keys[i]
		#btn.set_size(btnsize)
		
		btn.add_to_group("choices")
		get_node("buttons").add_child(btn)
		btn.connect("pressed", self, "_on_button_pressed", [i])
		#get_node(str(i)).text =  str(i) +  ": " + keys[i]
		i += 1

func load_choices_from_path():
	i = 1
	var btn
	var dialogKeys = dialogPath[dialogPath_pos]
	for key in dialogKeys:
		btn = Button.new()
		btn.set_name("btn-" + str(i))
		btn.text = str(i) + ":  " + dialogKeys[i]
		#btn.set_size(btnsize)
		
		btn.add_to_group("choices")
		get_node("buttons").add_child(btn)
		btn.connect("pressed", self, "_on_button_pressed", [i])
		i += 1
	
	

func advance_dialog_path():
	get_tree().call_group(0, "choices", "free")
	print("Advancing dialogue...")
	if( dialogPath.size() >= dialogPath_pos -1 ):
		keys = dialogPath[dialogPath_pos]
		choice_picked = false
		current_choice = null
		load_choices_from_path()
		#load_choices(keys)
		errbody_got_choices()
		start_choice()
	else:
		reset_choices()

func advance_dialog_path_to(pos):
	dialogPath_pos = pos
	advance_dialog_path()

func _ready():
	#load_choices(keys)
	get_node("Label").set_text("What do you like?")
	#load_choices_from_path()
	#errbody_got_choices()
	#start_choice()
	reset_path()


func make_choice(index):
	if ( is_dialogPath_finished() ):
		return
	set_process_input(false)
	if( choices.size() >= index ):
		# hide all choices
		get_tree().call_group(0, "choices", "hide")
		# but unhide the one we picked
		if( get_node("buttons/btn-" + str(index)) ):
			get_node("buttons/btn-" + str(index)).call_deferred("show")
		
		# set flags for going forward
		choice_picked = true
		current_choice = index;
		
		dialogPath_pos += 1
		
		if( current_choice == 1 ):
			advance_dialog_path_to(1)
		elif( current_choice == 2):
			advance_dialog_path_to(2)

func is_dialogPath_finished():
	return ( dialogPath_pos >= (dialogPath.size() - 1) )

func _on_button_pressed(index):
	get_node("init").hide()
	if ( is_dialogPath_finished() ):
		get_tree().call_group(0, 'choices', 'queue_free')
		get_node("Label").set_text("I should go.")
		return
	else:
		make_choice(index)

func reset_choices():
	choices = get_tree().get_nodes_in_group('choices');
	if( choices.size() > 0 ):
		for node in choices:
			node.show()
	set_process_input(true)
	start_choice()
	choice_picked = false

func reset_path():
	i = 1
	dialogPath_pos = 0
	choice_picked = false
	current_choice = null
	get_node("Label").set_text("What do you like?")
	get_tree().call_group(0, 'choices', 'free')
	load_choices_from_path()
	errbody_got_choices()
	set_process_input(true)