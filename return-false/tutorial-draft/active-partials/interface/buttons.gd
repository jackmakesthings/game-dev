extends VBoxContainer



var savepath = "res://savegame.txt"
var utils = preload("res://scripts/utils.gd")

var player
var quit_btn
var cancel_btn
var load_btn
var save_btn
var reset_btn
var main_menu_btn

var menu

###### savefiles

func new_file(path):
	utils.save_game({}, path)
	print("Created new file at ", path)
	
	
#### new
func _on_reset_pressed():
	_cancel_quit()
	var qs = get_node("/root/scene/quests").get_children()
	for q in qs:
		q.set_current_state("20")
	pass
	
#### save
func _on_save_pressed():
	
	
	var data = {}
	data["player_x"] = player.get_pos().x
	data["player_y"] = player.get_pos().y
	data["time"] = OS.get_time()
	data["date"] = OS.get_date()
	data["quest_states"] = get_node("/root/game")["quest_states"]
	
	#utils.save_game(data, savepath)
	
	get_parent().get_parent().get_node("Node/Control/PopupPanel").popup()
	get_parent().get_parent().get_node("Node").raise()
	get_parent().get_parent().get_node("Node/Control").show()
	
	#print(data)
	
	_cancel_quit()
	#print("saved player position as ", data.player_x, ", ", data.player_y, " to ", savepath);
	
func _on_save_menu_closed():
	get_parent().get_parent().get_node("menu_window").raise()

#### load
func _on_load_pressed():

	print("Pressed load button")
	print(get_tree().get_current_scene().get_filename())
	#var loaded = utils.get_json(savepath)
	#print("loaded data is", loaded)	
#	var data = {}
#	data["player_x"] = 300
#	data["player_y"] = 500
	utils.goto_scene("res://adjacent-scene.xml", {})
	
	
#	
#	if( loaded.has("player_x") and loaded.has("player_y")):
#		player.set_pos(Vector2(loaded["player_x"], loaded["player_y"]))
#	
#	if( loaded.has("quest_states") ):
#		for q in loaded["quest_states"]:
#			print("savefile has quest ", q, " at state ", loaded["quest_states"][q])
#			get_node("/root/game").update_quest(q, loaded["quest_states"][q])
#	
#	print("Loaded!")
#	menu.hide_menu()
#	_cancel_quit()
	
	#print(loaded_data)


#### back to main menu
func _on_mm_pressed():
	print("Back to menu")
	#menu.hide_menu()
	utils.goto_scene("res://sandbox/main-menu.xscn", null)

#### quit
func _on_quit_pressed():
	var red = Color("#ec1300")

	quit_btn.set_text("confirm")
	#quit_btn.set("custom_colors/font_color", red)
	quit_btn.set("custom_colors/font_color_hover", red)
	
	quit_btn.disconnect("pressed", self, "_on_quit_pressed")
	quit_btn.connect("pressed", self, "_quit_game")
	
	main_menu_btn.hide()
	cancel_btn.show()


func _cancel_quit():

	cancel_btn.hide()
	main_menu_btn.show()
	
	#quit_btn.set("custom_colors/font_color", null)
	quit_btn.set("custom_colors/font_color_hover", null)
	
	quit_btn.set_text("quit")
	
	quit_btn.disconnect("pressed", self, "_quit_game")
	quit_btn.connect("pressed", self, "_on_quit_pressed")
	



func _quit_game():
	print("bye")
	get_tree().quit()
#####


func _enter_tree():
	utils = get_node("/root/utils")


func _ready():
	
	quit_btn = get_node("quit")
	save_btn = get_node("save")
	load_btn = get_node("load")
	reset_btn = get_node("start over")
	cancel_btn = get_node("cancel")
	main_menu_btn = get_node("main menu")
	
	menu = get_node("/root/scene/menu")
	player = get_node("/root/scene").get("player")
	
	cancel_btn.hide()
#	save_btn.connect("released", self, "_on_save_pressed")
#	load_btn.connect("released", self, "_on_load_pressed")
	quit_btn.connect("pressed", self, "_on_quit_pressed")
#	reset_btn.connect("released", self, "_on_reset_pressed")
#	cancel_btn.connect("released", self, "_cancel_quit")
#	main_menu_btn.connect("released", self, "_on_mm_pressed")


