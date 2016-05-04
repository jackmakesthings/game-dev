# NPC base class
extends Area2D

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


# TODO: better handling of global-ish vars like player node
# maybe set up a dependencies pattern?
onready var Player = get_parent().find_node("player")
onready var MUI = get_tree().get_current_scene().find_node("MessageUI")

onready var x = get_node(approach_point)
onready var trigger = get_node(trigger_area)
onready var sprite = get_node('Sprite')
onready var collider = get_node('collider')

var player_nearby = false
var dialog_branches = [\
{"dialog_label": "Robots", "active": true}, \
{"dialog_label": "Humans", "active": true}, \
{"dialog_label": "Aliens", "active": false} \
]



## Input & player redirection ##
# Connected to the 'pressed' signal on the TextureButton.
func _on_click():	
	# Player's here already? Let's talk.
	# Player's somewhere else? Call them over.
	if Utils.is_player_nearby(trigger):
		get_tree().set_input_as_handled()
		start_interaction()
	else:
		Player.halt()
		var destination = get_canvas_transform().xform(x.get_global_pos())
		Utils.fake_click(destination, 1)
		yield(Player, "done_moving")
		Player.orient_towards(_get_orientation())
		start_interaction()



# Figure out where the player will stand relative to the NPC
func _get_orientation():
	var pos1 = collider.get_pos()
	var pos2 = x.get_pos()
	return pos1 - pos2


## Init or decline conversation ##
func start_interaction():
	if dialog_branches.empty():
		print("no dialogs!")
		end_interaction()
	else:
		# TODO: this works, convert it to use state/pointer/quest logic
		var active_branches = Array()
		for branch in dialog_branches:
			if branch.active:
				active_branches.append(branch)
		present_conversations(active_branches)



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
	
	# Only a likely issue in subscenes, test scenes, etc.
	if !MUI:
		return "No MUI!"

	# Nothing to talk about: (shouldn't happen at this point)
	if dialog_branches == null or dialog_branches.size() < 1:
		end_interaction()

	# Only one thing to talk about:
	elif dialog_branches.size() == 1:
		MUI.clear()
		MUI.say(single_option_fallback)
		MUI._Responses.add_close()
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
	MUI.clear()
	MUI.say(branch.dialog_label + " it is!")
	MUI._Responses.add_close("Okay.")
	pass


# Called when there's nothing to talk about
# Either show the fallback ("calibrations") or don't, depending on the show_fallback property
func end_interaction():
	if !MUI:
		return "No MUI!"
	if no_options_fallback and show_fallback:
		MUI.clear()
		MUI.say(no_options_fallback)
		MUI._Responses.add_close()
		MUI.open()
	else:
		MUI.clear()
		MUI.close()
	return 0


