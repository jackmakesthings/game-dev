# Main game logic

extends Node
var Scene = null
var Player = null
var MessageUI = null

func set_scene(scene_path):
	var _scene = load(scene_path).instance()
	if Scene:
		queue_free(Scene)
		Scene = null
	add_child(_scene)
	Scene = _scene

func _ready():
	MessageUI = load("res://systems/dialogue/Dialogue.Example.tscn").instance()
	add_child(MessageUI)
	set_scene("res://systems/environment/_Environment.tscn")
	# Called every time the node is added to the scene.
	# Initialization here
	pass


