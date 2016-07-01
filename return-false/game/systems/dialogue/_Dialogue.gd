# Dialogue UI base class (aka MUI/MessageUI)
# This goes with the Dialogue subscene, which gets instanced as MessageUI
# under the root game node. This is the UI used for conversations with NPCs.
extends Node


# Member Vars

# text_path     : Nodepath; the root of the dialogue ui (a Popup-based node)
# response_path : Nodepath; the container node for player responses
# dialog_path   : Nodepath; the container node for NPC dialogue text
#
# text_box      : Node; the node found at text_path
# response_box  : Node; the node found at response_path
# dialog_box    : Node; the node found at dialog_path
#
# is_active     : Boolean; whether the dialogue is open
# _Dialogue, _Responses, _Root: descendant instance references

export(NodePath) var text_path
export(NodePath) var response_path
export(NodePath) var dialog_path

onready var text_box = get_node(text_path)
onready var response_box = get_node(response_path)
onready var dialog_box = get_node(dialog_path)

var is_active
var _Dialogue
var _Responses
var _Root


# Signals

signal dialog_opened
signal dialog_closed
signal dialog_cleared


# Methods


##
# open
# Shows the dialogue UI
##
func open():
	if !is_active:
		_Root.popup()
		is_active = true
		emit_signal("dialog_opened")


##
# close
# Hides the dialogue UI
##
func close():
	_Root.hide()
	is_active = false
	emit_signal("dialog_closed")


##
# clear
# Removes all text and options
##
func clear():
	_Dialogue.clear()
	_Responses.clear()
	emit_signal("dialog_cleared")


##
# setup
# Creates all the necessary subclass instances
##
func setup():
	_Root = dialog_box
	_Dialogue = Dialogue.new(text_box, self)
	_Responses = ResponseList.new(response_box, self)
	close()


##
# _ready 
# Just calls setup
##
func _ready():
	setup()


##
# say(text)
# Shortcut for defining the text to show
#
# @text : String; Text (bbcode allowed) to put in the dialog box
##
func say(text):
	_Dialogue.make(text)


##
# response(obj)
# Shortcut for adding one response option
#
# @obj : Dictionary; one response object ({ text: "", actions: [] })
##
func response(obj):
	return _Responses.add_response(obj.text, obj.actions)


##
# responses(arr)
# Shortcut for adding multiple response options
#
# @arr : Array; Set of response objects
##
func responses(arr):
	return _Responses.add_responses(arr)


func show_branch(branch, npc):
	return _Responses.add_branch_option(branch, npc)

# Subclass: Dialogue
# Holds all the methods for dealing with the text area that holds NPC text
# Note: these should not generally be accessed directly;
# use the API from the parent class (MessageUI.say vs this.make)
class Dialogue:
	
	extends Node

	var text = ""
	var node
	var owner
	signal loaded(text)
	signal cleared

	func _init(text_box, owner):
		self.node = text_box
		self.owner = owner
	
	func make(from_text):
		if from_text == null:
			return

		var output = ""
		if typeof(from_text) == TYPE_ARRAY:
			for i in from_text:
				output = output + str(i)
		else:
			output = from_text
		
		node.set_bbcode(output)
		text = node.get_bbcode()
		emit_signal("loaded", text)

	func clear():
		node.clear()
		text = null
		emit_signal("cleared")


# Subclass: ResponseList
# Holds all the methods relating to the response set and its container
# Same disclaimer as above; use parent API methods
class ResponseList:
	
	extends Node
	
	var node
	var owner
	var responses = []
	var has_responses
	signal loaded(responses)
	signal cleared

	func _init(response_box, owner):
		self.node = response_box
		self.owner = owner
		owner.add_child(self)
		
	#func _enter_tree():
		#self.owner = get_tree().get_current_scene().find_node("MessageUI")

	func add_response(text, actions):
		var response = Button.new()
		response.set_text(text)
		response.set_text_align(0)

		response.add_to_group('responses')
		responses.append(response)
		node.add_child(response)
		response.raise()
		
		if actions.size() > 0:
			for action in actions:
				if typeof(action.target) == TYPE_STRING:
					var new_target = get_tree().get_root().get_node(action.target)
					action.target = new_target

				if action.has('args'):
					response.connect('pressed', action['target'], action['fn'], action['args'])
				else:
					response.connect('pressed', action['target'], action['fn'])

		has_responses = true
		return response

	func add_responses(response_array):
		for response in response_array:
			add_response(response['text'], response['actions'])
		has_responses = true
		emit_signal("loaded", responses)

	func add_close(_text='<Leave.>'):
		var _actions = [{
			fn = "close",
			target = owner,
			args = []
		}]
		owner.response({ "text": _text, "actions": _actions})

	func add_collect(_text='<Pick up.>', item_node=null):
		var _actions = [{
			fn = "collect",
			target = item_node,
			args = []
		}]
		add_response(_text, _actions)

	func add_branch_option(branch, npc):
		var _text = branch.dialog_label
		var _actions = [{
			fn = "enter_branch",
			target = npc,
			args = [branch]
		}]
		add_response(_text, _actions)

	func clear():
		if responses != null and responses.size() > 0:
			for response in responses:
				response.queue_free()
		responses = []
		has_responses = false
		emit_signal("cleared")
