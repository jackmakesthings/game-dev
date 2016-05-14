
extends Panel

# member variables here, example:
# var a=2
# var b="textvar"

var new_game_btn

func _ready():
	new_game_btn = find_node("Button")
	if get_tree().get_current_scene().has_method('_enter_game'):
		new_game_btn.connect("pressed", get_tree().get_current_scene(), "_enter_game")
