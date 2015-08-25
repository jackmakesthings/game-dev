######
# global game ui - menus etc.


extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var journal
var menu

func _ready():
	journal = get_node("/root/scene/journal_ui")
	menu = get_node("/root/scene/menu")
	pass

func _on_journal_pressed():
	menu.hide_menu()
	journal.toggle_journal()


# work in progress
func _on_menu_pressed():
	journal.hide_journal()
	menu.toggle_menu()
	pass