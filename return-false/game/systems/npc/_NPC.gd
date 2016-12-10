# NPC base class
extends CollisionObject2D

# trigger_area: Nodepath; generally the NPC root node, used for "player nearby" detection
# approach_point: Nodepath; the position2D used to direct the player over
# single_option_fallback: String; starting dialogue if only one topic exists
# multi_option_fallback: String; starting dialogue if several topics exist
# no_options_fallback: String; dialogue if no topics exist
# show_fallback: Boolean; Set to false to suppress showing the no_options_fallback

export(NodePath) var trigger_area
export(NodePath) var approach_point
export(String) var single_option_fallback
export(String) var multi_option_fallback
export(String) var no_options_fallback
export(bool) var show_fallback

# Node references
onready var Player = Game.Player
onready var MessageUI = Game.MessageUI

onready var x = get_node(approach_point)
onready var trigger = get_node(trigger_area)
onready var sprite = get_node('Sprite')
onready var collider = find_node('collider')

# player_nearby   : Boolean; is Player close enough to talk to?
# dialog_branches : Array; the topics this NPC can talk about
var player_nearby = false
var dialog_branches = []


# Methods

##
# _get_orientation(to)
# Small, private helper for getting an angle.
# TODO: this, and its use later, need some cleaning up.
# Figures out where the player will stand relative to the NPC
##
func _get_orientation(to):
	var pos1 = collider.get_global_pos()
	var pos2 = to.get_global_pos()
	return pos1 - pos2


func get_pos():
	if collider:
		return collider.get_pos()
	else:
		return get_pos()


##
# create_branch_option(branch)
# Helper for building "start this conversation"
# response options (for NPCs with multiple things
# to talk about.)
# TODO: should this be somewhere else? MessageUI? Branch?
#
# @branch : QuestBranch
##
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


##
# _on_click
# This is the first step invoked to start an interaction.
# Connected to the 'pressed' signal on the TextureButton.
# (We look up Player just in case our reference is outdated.)
##
func _on_click():	

	Player = Game.Player
	
	# No Player? Never mind.
	if !Player:
		return
	
	# Don't drag them over if there's nothing to talk about
	# (unless we want to show a "can't talk right now" fallback)
	if check_branches().size() < 1 and !show_fallback:
		get_tree().set_input_as_handled()
		return
		
	if Utils.is_player_nearby(trigger):
		# Player's here already?
		# Make sure they're facing us, then start talking.

		Player.orient_towards(collider.get_global_pos())
		get_tree().set_input_as_handled()
		start_interaction()
		print("chat!")

	else:
		# Player's somewhere else? Call them over,
		# turn them towards us, then start talking.

		var destination = get_canvas_transform().xform(x.get_global_pos())
		Utils.fake_click(destination, 1)
		Game.last_action = { 'event': 'interact', 'target': self }

		yield(Player, "done_moving")

		# Make sure they actually stopped near the NPC
#		if Utils.is_player_nearby(trigger) and Player.conversation_queued:
		if Game.last_action.target != self:
			return
			
		Player.orient_towards(collider.get_global_pos())
		start_interaction()
		


## 
# start_interaction
# Called once the Player is close enough to talk to.
# Determines whether to proceed with a dialogue or not.
##
func start_interaction():
	var active_branches = check_branches()
	for branch in active_branches:
		print(branch.get_parent_state())
	if active_branches.empty():
		end_interaction()
	else:
		present_conversations(active_branches)

##
# check_branches
# Loops through all the quest branches this NPC has access to
# and returns the ones with dialogue at their active states.
##
func check_branches():
	var active_branches = Array()
	for branch in dialog_branches:
		if branch.has_active_state() and active_branches.find(branch) < 0:
			active_branches.append(branch)
	return active_branches


##
# present_conversations(dialog_branches)
# Once we have an array of the NPC's active branches,
# this builds a dialogue to let the player choose
# what to talk about. Text comes from the *_fallback options.
#
# @dialog_branches: Array; open conversations
##
func present_conversations(dialog_branches):
	
	MessageUI = Game.MessageUI
	
	# Covering for lack of MessageUI in subscenes, test scenes, etc.
	if !MessageUI:
		print("where is MessageUI")
		return "No MessageUI!"

	# Nothing to talk about: (in theory this will never happen)
	if dialog_branches == null or dialog_branches.size() < 1:
		end_interaction()

	# Only one thing to talk about:
	elif dialog_branches.size() == 1:
		MessageUI.clear()		
		MessageUI.say(single_option_fallback)
		MessageUI.show_branch(dialog_branches[0], self)
		MessageUI.open()

	# Several things to talk about:
	elif dialog_branches.size() > 1:
		var options = Array()
		var option
		for branch in dialog_branches:
			option = MessageUI.show_branch(branch, self)
			options.append(option)

		MessageUI.clear()
		MessageUI.say(multi_option_fallback)
		MessageUI.responses(options)
		MessageUI.open()


##
# enter_branch(branch)
# Kicks off the current dialogue for a given branch.
# This gets called when the player selects a topic.
#
# @branch : QuestBranch
##
func enter_branch(branch):
	var _state = branch.get_parent_state()
	if !branch.has_state(_state):
		MessageUI.close()
		return

	MessageUI.clear()
	MessageUI.say(branch.text_at_state(_state))
	for response in branch.responses_at_state(_state):
		branch.build_response(response)	
	MessageUI.open()
	pass


##
# end_interaction
# Called when there's nothing to talk about
# Either show the fallback ("calibrations") or don't, 
# depending on the show_fallback property
##
func end_interaction():
	if !MessageUI:
		return "No MessageUI!"
	if no_options_fallback and show_fallback:
		MessageUI.open()
		MessageUI.clear()
		MessageUI.say(no_options_fallback)
		MessageUI._Responses.add_close()
	else:
		MessageUI.clear()
		MessageUI.close()
	return 0
