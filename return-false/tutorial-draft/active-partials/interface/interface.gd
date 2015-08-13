
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var journal

func _ready():
	journal = get_node("/root/scene/journal_ui")
	pass

func _on_journal_pressed():
	journal.show_journal()