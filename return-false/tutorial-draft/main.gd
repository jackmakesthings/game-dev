extends Node2D

var player
var MUI
var menu

const player_scene = preload("res://active-partials/player/_robot.xml")

func _init():
	player = player_scene.instance()
	
func _enter_tree():
	get_node("stage/nav/floor/bodies").add_child(player)
	
func _ready():
	#player = get_node("stage/nav/floor/bodies/robot")
	MUI = get_node("message-ui")
	get_tree().set_current_scene(get_tree().get_current_scene())
	