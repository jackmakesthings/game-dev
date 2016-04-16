extends "./_Dialogue.gd"

var ln = "------------"

func test_open():
	open()
	print(ln)
	print("Opening...", is_active)

func test_close():
	close()
	print(ln)
	print("Closing...", !is_active)

func test_clear():
	open()
	_Dialogue.make("This will be cleared.")
	_Responses.add_close()
	clear()
	print("Cleared dialogue and responses.")

func test_dialogue_str():
	open()
	_Dialogue.clear()
	_Dialogue.make("This is a string.")
	print(ln)
	print("Dialogue.node.get_bbcode() = ", _Dialogue.node.get_bbcode())
	print("Dialogue.text = ", _Dialogue.text)

func test_dialogue_arr():
	open()
	_Dialogue.clear()
	_Dialogue.make(["This ", "is ", "an ", "array."])
	print(ln)
	print("Dialogue.node.get_bbcode() = ", _Dialogue.node.get_bbcode())
	print("Dialogue.text = ", _Dialogue.text)

func test_dialogue_clear():
	_Dialogue.clear()
	if _Dialogue.node.get_bbcode() == "":
		print(ln)
		print("Cleared!")
	else:
		print(ln)
		print("Uh oh - tried to clear but bbcode is ", _Dialogue.get_bbcode())

func test_close_button():
	open()
	_Responses.add_close()
	print(ln)
	print("Close button generated!")

func test_single_response():
	open()
	var r_actions = [{
		fn = "close",
		target = _Responses.owner,
		args = []
	}]

	_Responses.add_response("Bespoke close button.", r_actions)
	print(ln)
	print("Responses: ", _Responses.responses)

func test_response_array():
	open()
	var r_1 = {
		text = "One response",
		actions = [{
			fn = "clear",
			target = _Responses.owner,
			args = []
			}]
		}

	var r_2 = {
		text = "Another response",
		actions = [{
			fn = "make",
			target = _Dialogue,
			args = ["button pressed!"]
		}]
	}

	var r_3 = {
		text = "One more",
		actions = [{
			fn = "add_close",
			target = _Responses,
			args = []
		}]
	}

	_Responses.add_responses([r_1, r_2, r_3])
	print(ln)
	print("Responses added: ", _Responses.responses)




func _ready():
	setup()
	test_open()
	
	#test_close()
	#test_open()
	test_dialogue_str()
	test_response_array()
	
	#test_clear()
	
	#test_dialogue_arr()
	#test_close_button()
	#test_dialogue_clear()
	
	#test_single_response()
	
	#test_close()
