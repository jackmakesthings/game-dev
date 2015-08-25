###### base game script - scripts/game.gd
# save, load, quit, all the really really global data stuff
# autoloaded as /root/game

extends Node

var savepath = "res://savegame.txt"
var utils = preload("res://scripts/utils.gd").new()

###### savefiles

func new_file(path):
	utils.save_game({}, path)
	print("Created new file at ", path)
	
	
#### new
func _on_new_pressed():
	pass
	
#### save
func _on_save_pressed():
	var data = { "key": "value", "cat": "ridiculous" }
	utils.save_game(data, savepath)
	print("saved data to ", savepath);

#### load
func _on_load_pressed():
	var data = utils.get_json(savepath)
	print(data)

#### quit
func _on_quit_pressed():
	var red = Color("#ec1300")
	var quit = get_node("/root/base/menu_layer/Control/menu_window/buttons/quit")

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



# todo: move to its own file, probably
####### template for saving game data			
class game_state:

	export var player_position = Vector2()
	export(PackedScene) var active_scene
	
	#testing
	export var arbitrary_string = ""
	export var arbitrary_number = 5
	export(NodePath) var arbitrary_node
	export(Resource) var arbitrary_resource
	export(Texture) var arbitrary_texture
	
	
	export var quests = {
		1: "tutorial",
		2: "basic-repairs",
		3: "data-recovery",
		4: "social-skills",
		5: "explore-the-lab"
	}
	
	export var quest_status = {
		1: -1,
		2: -1,
		3: -1,
		4: -1,
		5: -1
	}
	
	