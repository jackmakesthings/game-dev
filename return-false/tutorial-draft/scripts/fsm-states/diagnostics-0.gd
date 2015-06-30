
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
		"dialog": "Fix the thing",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("cabinet", {
		"dialog": "This cabinet is overflowing with poorly-organized spare parts.",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("terminal", {
		"dialog": "This terminal is inoperable.",
		"options": [{
			"text": "Leave",
			"endState": currentState
		}]
	});
	
	#printt(fsm.cabinet)