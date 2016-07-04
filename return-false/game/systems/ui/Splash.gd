
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

onready var new_game_btn = find_node('new')
onready var config_btn = find_node('config')

func _ready():
	if get_tree().get_current_scene().has_method('_enter_game'):
		new_game_btn.connect("pressed", get_tree().get_current_scene(), "_enter_game")

	if get_tree().get_current_scene().has_method('set_scene'):
		config_btn.connect('pressed', get_tree().get_current_scene(), 'set_scene', ['res://systems/ui/Config.tscn'])
