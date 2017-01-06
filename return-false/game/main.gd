# Main game logic
# This lives on the root Game node and holds global setup methods.

extends Node

# Member vars

# Scene        : Node; reference to the current environment
# Player       : Node; reference to the Player character tree
# MessageUI    : Node; reference to the Dialgoue UI 
# NPCManager   : Node; reference to the handler for all NPCs
# QuestManager : Node; reference to the handler for quests
# HUD		   : Node; reference to the persistent UI layer

var Scene = null
var Player = null
var MessageUI = null
var NPCManager = null
var QuestManager = null
var HUD = null

var last_player_pos = Vector2(500,700)

var last_action = { 'event': null, 'target': null }

var current_floor
var current_room

export(String, FILE) var initial_scene # where do we start?

onready var anim = find_node('fader')

signal player_ready(Player)

# Methods


func fade_out():
	anim.get_parent().get_parent().set_layer(5)
	anim.play('fade_out')

func fade_in():
	anim.play('fade_in')
	yield(anim, 'finished')
	anim.get_parent().get_parent().set_layer(-1)

##
# setup(name, path, raise)
# Generic helper for initializing singletons and global reference nodes
#
# @name : String; the name to instance and reference the scene as
# @path : String; path to the scene file
# @raise : Boolean; whether to move the instance once it's created
##
func setup(name, path, raise=false):
	var _instance = load(path).instance()
	add_child(_instance)
	_instance.set_name(name)
	self.set(name, _instance)
	Game.set(name, _instance)
	if raise:
		_instance.raise()
	return self[name]


##
# set_scene(scene_path)
# Like setup, but specialized for setting the initial environment scene
#
# @scene_path : String; path to the environment scene file
##
func set_scene(scene_path):
	var _scene = load(scene_path).instance()
	if Scene != null:
		Scene.queue_free()
		#Scene = null
	add_child(_scene)
	Scene = _scene
	return Scene


##
# change_scene(scene_path)
# Helper for environments that also takes care of putting the Player
# where it needs to go (as a child of Scene.object_layer)
#
# @scene_path : String; path to the new environment scene file
##
func change_scene(scene_path, animate=true):
	
	if Player:
		last_player_pos = Player.get_pos()
	
	if animate:
		fade_out()
		yield(anim, 'finished')
		
	set_scene(scene_path)
	
	if animate:
		fade_in()


##
# set_player
# Another specialized setup method, this one for the Player node
##
func set_player():
	var _player = load("res://systems/character/Player.tscn").instance()
	var _destination
	
	if Scene.get('object_layer'):
		_destination = Scene.object_layer
	elif Scene.find_node('YSort'):
		_destination = Scene.find_node('YSort')
	else:
		_destination = Scene.get_child(0)
	_destination.add_child(_player)
	_player.set_global_pos(last_player_pos)
	_player.find_node('Camera2D').force_update_scroll()
	Player = _player
	return Player


##
# _enter_game
# This gets called when switching from a non-game scene 
# (like the initial game menu) to an in-game one.	
##	
func _enter_game():	
	setup('MessageUI', "res://systems/dialogue/Dialogue.Example.tscn")
#	change_scene("res://systems/environment/_Environment.tscn", false)
	change_scene(initial_scene, false)
	setup('NPCManager', "res://systems/npc/NPC.Manager.tscn")
	setup('QuestManager', "res://systems/quests/Quest.Manager.tscn", true)
	setup('HUD', "res://systems/ui/HUD.tscn")
	MessageUI.raise()


##
# _ready
# Starts the game at the base game menu scene
##
func _ready():
	Game.SoundPlayer = find_node('SamplePlayer')
	Game.MusicPlayer = find_node('StreamPlayer')
	set_scene("res://systems/ui/Splash.tscn")


##
# quit handling 
##
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		QuestManager.save_current_quests()
		Data.save_data()
		get_tree().call_deferred('quit') # default behavior
