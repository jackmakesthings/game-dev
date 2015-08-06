
extends State

# member variables here, example:
# var a=2
# var b="textvar"

var currentState = 5
var fsm



func _ready():
	fsm = get_parent()
	pass

func state_enter(entity):
	print("Entering state 100")
	fsm.set("engineer", {
		"dialog": "Engineer @ 100",
		"options": [
			{ 
			"text": "Leave", 
			"endState": currentState
			}
		]
	});

	fsm.set("cabinet", {
		"dialog": "Cabinet @ 100",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("terminal", {
		"dialog": "Terminal @ 100",
		"options": [{
			"text": "Run diagnostic function",
			"endState": currentState + 1
		},
		{
			"text": "Leave",
			"endState": currentState
		}]
	});
	
	#printt(fsm.cabinet)