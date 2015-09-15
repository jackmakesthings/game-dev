extends Node2D

var player
var MUI
var menu

func _enter_tree():
	player = get_node("stage/nav/floor/bodies/robot")
	
func _ready():
	player = get_node("stage/nav/floor/bodies/robot")
	MUI = get_node("message-ui")
	get_tree().set_current_scene(get_tree().get_current_scene())
	