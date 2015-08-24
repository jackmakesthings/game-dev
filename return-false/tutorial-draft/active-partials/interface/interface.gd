######
# global game ui - menus etc.


extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var journal
var menu_screen

func _ready():
	journal = get_node("/root/scene/journal_ui")
	menu_screen = get_node("/root/scene/journal_ui")
	pass

func _on_journal_pressed():
	journal.show_journal()


# work in progress
func _on_menu_pressed():
	journal.hide_journal()
	pass