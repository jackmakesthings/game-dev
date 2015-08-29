####### Quest branch - base template/class
# data/dialogue/branch.gd

extends Node

export var Q_ID = 1  # "tutorial"
export var A_ID = "engineer"  # "engineer"
export var states = []
export var init_at = 20

var game
# each branch has its own validator to check when it can be init'd

func _can_activate():
	# prereq logic for the branch would go here
	# check various conditions before activating (or not)
	game = get_node("/root/game")
	var quests = game["quests"]
	var actors = game["actors"]
	
	if self._completed() == true or self.states.empty():
		return false
	if game.quest_exists(Q_ID) == false:
		return false
	#if ( actors[A_ID] == null ) or ( actors.has(A_ID) == false ):
	#	return false
	else:
		return true
		
	return true
	
func _on_activate():
	game = get_node("/root/game")
	print("Quest is ", Q_ID, " and actor is ", A_ID)
	#emit_signal("branch_activated", Q_ID, A_ID, init_at)
	game.update_quest(Q_ID, init_at)


func _on_complete():
	game = get_node("/root/game")
	var end = game.get_state(game.quests[Q_ID])
	print("Finished quest ", Q_ID, " with actor ", A_ID)
	#emit_signal("branch_completed", Q_ID, A_ID, end)