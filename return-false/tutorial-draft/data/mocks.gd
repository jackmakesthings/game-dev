#### dummy/placeholder/test data, for drop-in use while prototyping

extends Node

class MUI:

	#### dialogue data
	
	var dialogue_text_str = "This is a string of dialogue. "
	var dialogue_bbcode_str = "This is some sweet [color=#00ccdd]bbcode[/color]"
	var dialogue_array = [dialogue_text_str, dialogue_bbcode_str]
	
	#### response data
	
	var mocks = self

	var response_action_1 = {
		fn = "do_thing_1",
		target = mocks,
		args = [100]
	}
	
	var response_1 = {
		text = "Choose thing 1",
		actions = [response_action_1]
	}
	
	var response_action_2 = {
		fn = "do_thing_2",
		target = mocks,
		args = [200]
	}
	
	var response_2 = {
		text = "Choose thing 2",
		actions = [response_action_1, response_action_2]
	}
	
	var response_array = [response_1, response_2]
	
	func do_thing_1(args):
		print("Doing thing one with params ", str(args))
	
	func do_thing_2(args):
		print("Doing thing two with params ", str(args))
	
	
	
	func _ready():
		pass
		#mocks = get_node("/root/mocks")


#### Journal data

class JRNL:

	var entry1 = {
		entry_id = 001,
		title = "Hello World",
		body = "Beep boop",
		summary = "Beeped.",
		timestamp = "00:05"
	}
	
	var entry2 = {
		entry_id = 002,
		title = "My first day on the job",
		body = "Meep moop zarp",
		summary = "Zarped",
		timestamp = "01:10"
	}
	
	
	func fake_quest_action(id):
		var new_args = {}
		if( id == 1 ):
			new_args.title = "task: Do the thing"
			new_args.body = "I did the thing. Let me tell you about the thing I did."
			new_args.summary = "> Did thing."
			new_args.timestamp = "Whenever"
			new_args.entry_id = 001
		
		elif( id == 2 ):
			new_args.title = "task: Do the other thing"
			new_args.body = "They want me to do two whole things!"
			new_args.summary = "> Assigned other thing"
			new_args.timestamp = "Now"
			new_args.entry_id = 002
		
		elif( id == 3 ):
			new_args.title = "task: Do the other thing"
			new_args.body = "I did part of the other thing. I will do the rest of the thing later."
			new_args.summary = "> Began work on other thing"
			new_args.timestamp = "Today"
			new_args.entry_id = 002
		
		elif( id == 4 ):
			new_args.title = "task: Do the other thing"
			new_args.body = "I finished doing the other thing."
			new_args.summary = "> Completed other thing"
			new_args.timestamp = "Forever"
			new_args.entry_id = 002
		
		else:
			new_args.title = "---"
			new_args.body = "---"
			new_args.timestamp = "Never"
			new_args.entry_id = 666
	
		return new_args
		#update_journal(new_args)
