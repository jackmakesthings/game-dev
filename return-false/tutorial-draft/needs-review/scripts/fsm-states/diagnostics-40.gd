
extends State

# member variables here, example:
# var a=2
# var b="textvar"

var currentState = 2
var fsm


func _update_callback():
	print("!!!!!")


func _ready():
	fsm = get_parent()
	add_user_signal("update_state")
	#connect("update_state", fsm, "state_callback")
	pass

func state_enter(entity):
	#emit_signal("update_state")
	print("Entering state 40")
	fsm.set("engineer", {
		"dialog": "Engineer @ 40",
		"options": [
			{ 
			"text": "Leave", 
			"endState": currentState
			}
		]
	});

	fsm.set("cabinet", {
		"dialog": "Cabinet @ 40",
		"options": [
			{ 
			"text": "Close", 
			"endState": currentState
			}
		]
	});

	fsm.set("terminal", {
		"dialog": "Terminal @ 40",
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