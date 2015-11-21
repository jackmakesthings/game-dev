# message-ui/response-button.gd
# script for adjacent response-button.xml scene
# probably obsolete-ish, just a hover effect thing.

extends Button

func _ready():
	get_node("Label").set_text("•-")

func mouse_exit():
	get_node("Label").set_text("-")

func mouse_enter():
	get_node("Label").set_text(">")