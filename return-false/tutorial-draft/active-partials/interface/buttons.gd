# buttons.gd - current manager for the in-game main menu
# TODO: better name, possibly better location

extends Node

const RED = Color("#ec1300")
const SAVEFILE_DIR = "res://savegames"
const MAIN_MENU_SCENE = "res://assets/ui/main_menu_2.xscn"

var utils = preload("res://scripts/utils.gd")

var player

var quit_btn
var cancel_btn
var load_btn
var save_btn
var reset_btn
var main_menu_btn

var menu
var menu_layer
var default_menu
var save_menu
var load_menu

###### menu management and stuff



#### reset function - will probably go away, but it's here for now,
# in case it becomes useful during testing/building
func _on_reset_pressed():
	_cancel_quit()
	var qs = get_node("/root/scene/quests").get_children()
	for q in qs:
		q.set_current_state("0")



#### save
# the actual save actions are managed by the submenu;
# this function just triggers that submenu to appear
func _on_save_pressed():
	
	# TODO: this should probably be located somewhere central
	# like utils.gd, as a generic savedata-assembling function
	var data = {}
	data["scene"] = get_tree().get_current_scene().get_filename()
	data["player_x"] = player.get_pos().x
	data["player_y"] = player.get_pos().y
	data["time"] = OS.get_time()
	data["date"] = OS.get_date()
	data["quest_states"] = get_node("/root/game")["quest_states"]
	
	# show the submenu
	save_menu.open()
	# re-cache our list of saved files
	save_menu.show_file_list()
	# attach the data object to the submenu for later retrieval
	save_menu.set("data", data)
	# reset the quit button to its initial state, if needed
	_cancel_quit()



#### load
# works very similarly to save - the load submenu does all the work
# this function just displays that submenu
func _on_load_pressed():
	# show the submenu
	load_menu.open()
	# re-cache our list of saved files
	load_menu.show_file_list()
	# reset the quit button to its initial state, if needed
	_cancel_quit()



#### _on_sub_menu_closed	
# this gets called when either of the submenu popups is hidden
# it may seem redundant, and maybe it can be fixed up later,
# but both the popups and their parent controls need to be hidden
# or they block interactions aimed at the other controls
func _on_sub_menu_closed():
	load_menu.close()
	save_menu.close()
	default_menu.raise()



#### go to main menu
func _on_mm_pressed():
	utils.goto_scene(MAIN_MENU_SCENE, {})



#### quit
# this is called the first time you click quit
# it changes the 'quit' button to a 'confirm' button
# and shows a 'cancel' one in place of the one below it
func _on_quit_pressed():
	
	# change the look and text of the button
	quit_btn.set("text", "confirm")
	quit_btn.set("custom_colors/font_color_hover", RED)
	
	# also change what it does when clicked
	quit_btn.disconnect("pressed", self, "_on_quit_pressed")
	quit_btn.connect("pressed", utils, "quit_game")
	
	# visually replace 'main menu' with 'cancel'
	main_menu_btn.hide()
	cancel_btn.show()



# this gets called if you have hit quit once
# and then click anything other than 'confirm'
# it resets the quit button to its original state
# (if you click 'confirm', utils.quit_game() is called instead)
func _cancel_quit():
	
	# put the main menu button back where it was, hide cancel button
	cancel_btn.hide()
	main_menu_btn.show()
	# set the quit button back to its old text and appearance
	quit_btn.set("custom_colors/font_color_hover", null)
	quit_btn.set("text", "quit")
	# and hook it back up to its original functions
	quit_btn.disconnect("pressed", utils, "quit_game")
	quit_btn.connect("pressed", self, "_on_quit_pressed")



# make utils available ASAP
#func _enter_tree():
	



func _enter_tree():
	utils = get_node("/root/utils")
	# cache nodes and paths
	
	# buttons
	quit_btn      = get_node("quit")
	save_btn      = get_node("save")
	load_btn      = get_node("load")
	reset_btn     = get_node("start over")
	cancel_btn    = get_node("cancel")
	main_menu_btn = get_node("main menu")
	
	# menus and submenus
	menu          = get_node("/root/scene/menu")
	menu_layer    = menu.get_child(0)
	default_menu  = menu_layer.get_node("menu_window")
	save_menu     = menu_layer.get_node("submenu_save")
	load_menu     = menu_layer.get_node("submenu_load")
	
	# other nodes
	player        = get_node("/root/_").get("player")
	
	# hook up signals where needed
	# todo - either connect all via scene or all via code
#	save_btn.connect("pressed", self, "_on_save_pressed")
#	load_btn.connect("pressed", self, "_on_load_pressed")
	#quit_btn.connect("pressed", self, "_on_quit_pressed")