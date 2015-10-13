extends Node2D

var player
var stage
var MUI
var menu

const player_scene = preload("res://active-partials/player/_robot.xml")
const stage_scene = preload("res://active-partials/environment/FPO_stage_a.xml")

func _init():
	player = player_scene.instance()
	stage = stage_scene.instance()
	
func _enter_tree():
	add_child(stage)
	move_child(stage, 1)
	stage.get("body_layer").add_child(player)
	
	
func _ready():
	#player = get_node("stage/nav/floor/bodies/robot")
	stage.set_process_unhandled_input(true)
	MUI = get_node("message-ui")
	get_tree().set_current_scene(get_tree().get_current_scene())
	