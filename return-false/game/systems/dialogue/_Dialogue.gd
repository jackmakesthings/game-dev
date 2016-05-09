extends Node

var is_active

export(NodePath) var text_path
export(NodePath) var response_path
export(NodePath) var dialog_path

onready var text_box = get_node(text_path)
onready var response_box = get_node(response_path)
onready var dialog_box = get_node(dialog_path)

var _Dialogue
var _Responses
var _Root

signal dialog_opened
signal dialog_closed
signal dialog_cleared

func open():
	if !is_active:
		_Root.popup()
		is_active = true
		emit_signal("dialog_opened")

func close():
	_Root.hide()
	is_active = false
	emit_signal("dialog_closed")

func clear():
	_Dialogue.clear()
	_Responses.clear()
	emit_signal("dialog_cleared")

func setup():
	_Root = dialog_box
	_Dialogue = Dialogue.new(text_box, self)
	_Responses = ResponseList.new(response_box, self)
	close()

func _ready():
	setup()



func say(text):
	_Dialogue.make(text)

func response(obj):
	return _Responses.add_response(obj.text, obj.actions)

func responses(arr):
	return _Responses.add_responses(arr)

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
		
	
	func _enter_tree():
		self.owner = get_tree().get_current_scene().find_node("MessageUI")

	func add_response(text, actions):
		var response = Button.new()
		response.set_text(text)
		response.set_text_align(0)

		response.add_to_group('responses')
		responses.append(response)
		node.add_child(response)
		response.raise()
				# TODO: only one connection allowed per signal;
		# may need to refactor this
		if actions.size() > 0:
			for action in actions:
		#		response.connect('pressed', action['target'], action['fn'], action['args'])
				if action.has('arg'):
					response.connect('pressed', action['target'], action['fn'], action['arg'])
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
		#add_response(_text, _actions)
		owner.response({ "text": _text, "actions": _actions})

	func add_collect(_text='<Pick up.>', item_node=null):
		var _actions = [{
			fn = "collect",
			target = item_node,
			args = []
		}]
		add_response(_text, _actions)

	func clear():
		if responses != null and responses.size() > 0:
			for response in responses:
				response.queue_free()
		responses = []
		has_responses = false
		emit_signal("cleared")
