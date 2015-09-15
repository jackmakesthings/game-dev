
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var menu_base
var menu_layer
var menu_popup

var menu_visible = false

signal menu_opened
signal menu_closed




func is_menu_visible():
	return menu_visible


func show_menu():
	menu_layer.set_layer(1)
	menu_popup.popup()
	menu_visible = true
	emit_signal("menu_opened")
	
	
func hide_menu():
	menu_layer.set_layer(-1)
	menu_popup.hide()
	menu_visible = false
	emit_signal("menu_closed")
	
	
func toggle_menu():
	if( is_menu_visible() == true ):
		hide_menu()
	else:
		show_menu()
		
		
		
func _ready():
	menu_base = self
	menu_layer = get_node("menu_layer")
	menu_popup = menu_layer.get_node("menu_window")
	hide_menu()
	
	menu_layer.set_layer(-1)
	
	add_user_signal("menu_opened", [])
	add_user_signal("menu_closed", [])
	
	
	get_node("/root/paths").set("menu", get_path())

	
