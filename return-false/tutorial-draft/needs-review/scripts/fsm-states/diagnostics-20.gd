
extends State

# member variables here, example:
# var a=2
# var b="textvar"

var currentState = 1
var fsm


func _on_updated():
	print("HI IM 20")

func _ready():
	fsm = get_parent()
	fsm.connect("update_state", self, "_on_updated")

func state_enter(entity):
	print("Entering state 20")
	fsm.set("engineer", {
		"dialog": "'The diagnostic utilities are all accessible through the terminal.\n Start with that.'",
		"options": [
			{ 
			"text": "Leave", 
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
		"dialog": "This terminal is inoperable. (Option to run diagnostic function will go here.)",
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