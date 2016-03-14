# testing randomization stuff

extends Node

onready var MUI = get_node("message-ui")
var strings = ["Beep", "Boop", "Meep", "Morp", "Zarp"]

var correct_options = ["Tiny", "A squish", "A cookie"]
var incorrect_options = ["A mighty hunter", "A genius", "Full of insights", "Big and strong", "Super helpful", "Reticent", "Logic-driven"]


func show_random_int():
	randomize()
	var i = randi() % 10
	MUI.flash_popup(str(i))
	
func show_random_str(arr=strings):
	var m = arr.size() - 1
	randomize()
	var i = randi() % m
	MUI.flash_popup(arr[i])
	
func pick_randomly(count,arr):
	var picked = []
	var i = 0
	while i < count:
		randomize()
		var r = randi() % arr.size()
		print(r)
		
		if picked.find(arr[r]) > -1:
			continue
		else:
			picked.append(arr[r])
			i = i + 1
	print(picked)
	return picked
	

func test():
	
	randomize()
	
	var wrong_answers = pick_randomly(3, incorrect_options)
	var right_answers = pick_randomly(1, correct_options)
	var close_action = { fn = "close",
						target = MUI,
						args = [] }
	
	var wrong_action = { fn = "flash_popup",
						target = MUI,
						args = ["LOL PLS"] }
	
	var right_action = { fn = "flash_popup",
						target = MUI,
						args = ["yeah p much"] }

	MUI.clear()
	MUI.clear_dialogue()
	
	MUI.close()
	
	MUI.make_dialogue("What is Choco?")
	
	for answer in right_answers:
		MUI.make_response(answer, [right_action, close_action])

	for answer in wrong_answers:
		MUI.make_response(answer, [wrong_action, close_action])
	
	var pause = Timer.new()
	pause.set_one_shot(true)
	pause.set_wait_time(1)
	add_child(pause)
	pause.start()
	yield(pause, "timeout")
	MUI.open()



