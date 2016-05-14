# Main game logic

extends Node
var Scene = null
var Player = null
var MessageUI = null
var NPCManager = null
var QuestManager = null

func setup(name, path, raise=false):
	var _instance = load(path).instance()
	add_child(_instance)
	_instance.set_name(name)
	self.set(name, _instance)
	if raise:
		_instance.raise()
	return self[name]
	
func set_scene(scene_path):
	var _scene = load(scene_path).instance()
	if Scene != null:
		Scene.queue_free()
		#Scene = null
	add_child(_scene)
	Scene = _scene
	return Scene

func set_player():
	var _player = load("res://systems/character/Player.tscn").instance()
	var _destination = Scene.object_layer
	_destination.add_child(_player)
	_player.set_pos(Vector2(340,200))
	Player = _player
	Scene.connect('walk_to', Player, 'update_path')
	return Player

func _ready():
	set_scene("res://systems/ui/Splash.tscn")
	
func _enter_game():	
	setup('MessageUI', "res://systems/dialogue/Dialogue.Example.tscn")
	set_scene("res://systems/environment/_Environment.tscn")
	set_player()
	setup('NPCManager', "res://systems/npc/NPC.Manager.tscn")
	setup('QuestManager', "res://systems/quests/Quest.Manager.tscn", true)
	MessageUI.raise()

