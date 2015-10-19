######
# global game ui - menus etc.


extends Control

# member variables here, example:
# var a=2
# var b="textvar"

var journal
var menu
var scene

func _ready():
	scene = get_node("/root/_").get("root")
	menu = scene.get("menu")
	journal = get_node("/root/scene/journal_ui")
	#menu = get_node("/root/scene/menu")
	#pass

func _on_journal_pressed():
	#pass
	menu.hide_menu()
	journal.toggle_journal()


# work in progress
func _on_menu_pressed():
	#menu = get_node("/root/_").get("menu")
	#scene.add_child(menu)
	#scene.move_child(menu, 0)
	#print(menu)
	journal.hide_journal()
	menu.toggle_menu()
	pass