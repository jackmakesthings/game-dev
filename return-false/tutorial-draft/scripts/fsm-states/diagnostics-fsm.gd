
extends StateMachine

# member variables here, example:
# var a=2
# var b="textvar"
var engineer
var cabinet
var terminal

var states
var currentState
var fsm

var sceneroot
var changing = false
var loopStates = false

func _input(ev):
	if changing:
		return
	elif (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		changing = true
		currentState = currentState + 1
		print(str(currentState), " of ", str(states.size()))
		if( states.size() > currentState ):
			fsm.change_state(states[currentState])
			sceneroot.update_labels()
		else:
			if( loopStates == true ):
				currentState = 0
				fsm.change_state(states[currentState])
				sceneroot.update_labels()
				pass
			else:
				print("No more states!")
				changing = true
				set_process_input(false)
			
		changing = false
		## - get_pos()    # convert our endpoint to be relative from start point
		#player.update_path(begin, end)


func _ready():
	fsm = self
	currentState = 0
	sceneroot = get_parent()
	states = get_children()
	fsm.set_current_state(states[0])
	fsm.first_enter()
	set_process_input(true)
	

	#get_node("40").emit_signal("update_state")

	# Initialization here
	pass


