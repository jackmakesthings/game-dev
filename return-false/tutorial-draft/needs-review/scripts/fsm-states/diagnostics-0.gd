
extends State

# member variables here, example:
# var a=2
# var b="textvar"

var currentState = 0
var fsm



func _ready():
	fsm = get_parent()
	pass

func state_enter(entity):
	print("Entering state 0")
	fsm.set("engineer", {
		"dialog": "'Fix the thing.'",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("cabinet", {
		"dialog": "--",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("terminal", {
		"dialog": "--",
		"options": [{
			"text": "Leave",
			"endState": currentState
		}]
	});
	
	#printt(fsm.cabinet)