extends Control

#var dialogSource
export var active_dialog = ""
var responses = [ ]


func _message(contents):
	pass
	#if( get_child(0) ):
	#	get_child(0).set("text", contents)

func get_active_dialog():
	return self.active_dialog

func set_active_dialog(dialogString):
	self.active_dialog = dialogString
	
func _set_responses(responseArray):
	self.responses = responseArray
	_message("New response set: ", str(responses))

func _add_response(response):
	var s = responses.size() + 1
	responses.resize( s )
	responses.append( response )
	_message("Added ", response)
	_message("New response set: ", str(responses))

func _ready():
	print(self.get_name() + " created!")
	var label = Label.new()

	label.set_name("label_" + self.get_name() )
	self.set_h_size_flags(3)
	self.set_v_size_flags(3)
	add_child(label)