extends VBoxContainer



var savepath = "res://savegame.txt"
var utils = preload("res://scripts/utils.gd").new()
var game
var player
var quit

###### savefiles

func new_file(path):
	utils.save_game({}, path)
	print("Created new file at ", path)
	
	
#### new
func _on_new_pressed():
	pass
	
#### save
func _on_save_pressed():
	var data = {}

	
	data["player_x"] = player.get_pos().x
	data["player_y"] = player.get_pos().y
	data["time"] = OS.get_time()
	data["date"] = OS.get_date()
	
	utils.save_game(data, savepath)
	print("saved player position as ", data.player_x, ", ", data.player_y, " to ", savepath);

#### load
func _on_load_pressed():
	var loaded = utils.get_json(savepath)
	
	if( loaded["player_x"] and loaded["player_y"]):
		player.set_pos(Vector2(loaded["player_x"], loaded["player_y"]))
	
	print("Loaded!")
	#print(loaded_data)

#### quit
func _on_quit_pressed():
	var red = Color("#ec1300")
	var quit = get_node("quit")

	print("clicked quit!")

	quit.set_text("> confirm")
	quit.set("custom_colors/font_color", red)
	quit.set("custom_colors/font_color_hover", red)
	quit.disconnect("pressed", self, "_on_quit_pressed")
	quit.connect("pressed", self, "_quit_game")

func _quit_game():
	print("bye")
	get_tree().quit()
#####


func _enter_tree():
	utils = get_node("/root/utils")


func _ready():
	print("hi!")
	quit = get_node("quit")
	game = get_node("/root/game")
	player = get_node("/root/scene").get("player")
#	game = preload("res://scripts/game.gd").new()
	add_child(game)
	
	get_node("save").connect("released", self, "_on_save_pressed")
	get_node("load").connect("released", self, "_on_load_pressed")
	get_node("quit").connect("released", self, "_on_quit_pressed")
	get_node("start over").connect("released", self, "_on_new_pressed")