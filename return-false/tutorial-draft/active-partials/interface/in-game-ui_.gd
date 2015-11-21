######
# global game ui - menus etc.
# active-partials/interface/in-game-ui_.gd

extends Control

var journal
var menu
var scene

func _ready():
	#scene = get_node("/root/_").get("root")
	scene = get_tree().get_current_scene()
	menu = scene.get("menu")
	journal = get_node("/root/scene/journal_ui")
	#menu = get_node("/root/scene/menu")
	#pass

func _on_journal_pressed():
	menu.hide_menu()
	journal.toggle_journal()


# work in progress
func _on_menu_pressed():
	journal.hide_journal()
	menu.toggle_menu()