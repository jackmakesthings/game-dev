# NPC base class
extends CollisionObject2D

# trigger_area: generally the NPC root node, used for "player nearby" detection
# approach_point: the position2D used to direct the player over
# single_option_fallback: Intro text, could be changed by quests as added, need to flesh out further
# multi_option_fallback: Default text for "there are multiple topics available" situations
# no_options_fallback: "Can this wait? Calibrations."
# show_fallback: Set to false to suppress showing the no_options_fallback
export(NodePath) var trigger_area
export(NodePath) var approach_point
export(String) var single_option_fallback
export(String) var multi_option_fallback
export(String) var no_options_fallback
export(bool) var show_fallback


onready var Player = get_tree().get_current_scene().Player
onready var MUI = get_tree().get_current_scene().MessageUI

onready var x = get_node(approach_point)
onready var trigger = get_node(trigger_area)
onready var sprite = get_node('Sprite')
onready var collider = find_node('collider')

var player_nearby = false
var dialog_branches = []


## Input & player redirection ##
# Connected to the 'pressed' signal on the TextureButton.
func _on_click():	
	Player = get_tree().get_current_scene().Player
	
	# No Player? Never mind.
	if !Player:
		return
	
	# Don't drag them over if there's nothing to talk about
	if check_branches().size() < 1 and !show_fallback:
		get_tree().set_input_as_handled()
		return
		
	# Player's here already? Let's talk.
	# Player's somewhere else? Call them over.
	if Utils.is_player_nearby(trigger):
		Player.orient_towards(_get_orientation(Player.find_node("CollisionShape2D")))
		get_tree().set_input_as_handled()
		yield(Player, "done_orienting")
		start_interaction()
	else:
		var destination = get_canvas_transform().xform(x.get_global_pos())
		Utils.fake_click(destination, 1)
		yield(Player, "done_moving")
		if Utils.is_player_nearby(trigger):
			Player.orient_towards(_get_orientation(x))
			yield(Player, "done_orienting")
			start_interaction()


# Figure out where the player will stand relative to the NPC
func _get_orientation(to):
	var pos1 = collider.get_global_pos()
	var pos2 = to.get_global_pos()
	return pos1 - pos2


## Init or decline conversation ##
func start_interaction():
	if dialog_branches.empty():
		end_interaction()
	else:
		var active_branches = check_branches()
		if active_branches.size() > 0:
			present_conversations(active_branches)
		else:
			end_interaction()

func check_branches():
		var active_branches = Array()
		for branch in dialog_branches:
			if branch.has_active_state() and active_branches.find(branch) < 0:
				active_branches.append(branch)
		return active_branches


# Create a "start talking about this" button for a given conversation
func create_branch_option(branch):
	var response = {
		text = branch.dialog_label,
		actions = [
			{
				fn = "enter_branch",
				target = self,
				args = [branch]
			}
		]
	}
	return response


# Translate available conversations into a dialogue
# using one of the fallbacks (single_option, multi_option) as text
# with response options to trigger each available conversation.
func present_conversations(dialog_branches):

	var options = Array()
	MUI = get_tree().get_current_scene().MessageUI
	
	# Only a likely issue in subscenes, test scenes, etc.
	if !MUI:
		print("where is MUI")
		return "No MUI!"

	# Nothing to talk about: (shouldn't happen at this point)
	if dialog_branches == null or dialog_branches.size() < 1:
		end_interaction()

	# Only one thing to talk about:
	elif dialog_branches.size() == 1:
		MUI.clear()
		MUI.say(single_option_fallback)
		MUI.response(create_branch_option(dialog_branches[0]))
		MUI.open()

	# Several things to talk about:
	elif dialog_branches.size() > 1:
		for branch in dialog_branches:
			var option = create_branch_option(branch)
			options.append(option)
		MUI.clear()
		MUI.say(multi_option_fallback)
		MUI.responses(options)
		MUI.open()


# Stub - this will be used to kick off a conversation branch, ultimately.
func enter_branch(branch):
	var _state = branch.get_parent_state()
	if !branch.has_state(_state):
		MUI.close()
		return

	MUI.clear()
	MUI.say(branch.text_at_state(_state))
	for response in branch.responses_at_state(_state):
		branch.build_response(response)	
	MUI.open()
	pass


# Called when there's nothing to talk about
# Either show the fallback ("calibrations") or don't, depending on the show_fallback property
func end_interaction():
	if !MUI:
		return "No MUI!"
	if no_options_fallback and show_fallback:
		MUI.open()
		MUI.clear()
		MUI.say(no_options_fallback)
		MUI._Responses.add_close()
	else:
		MUI.clear()
		MUI.close()
	return 0




#func _ready():
#	var temp_data = Utils.get_json("res://sandbox/sample-branch.json")
#	dialog_branches.append(temp_data)
