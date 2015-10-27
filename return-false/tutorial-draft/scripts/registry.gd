# global reference node

extends Node

var root
var stage
var player
var MUI
var menu
var journal
var quest_root
var quests

var tick = 0

var nodes = ["stage", "player", "MUI", "quest_root", "quests"]

var scripts = {
	PLAYER = "res://active-partials/player/player-k2d.gd",
	NPC = "res://active-partials/npcs/npc.gd",
	STAGE = "res://active-partials/environment/walkable-area.gd",
	MUI = "res://active-partials/message-ui/message-ui.gd",
	QUEST = "res://active-partials/quest-mgmt/quest.gd"
}

const scenes = {
	PLAYER = "res://active-partials/player/_robot.xml",
	MUI = "res://active-partials/message-ui/MUI_.xscn",
	MENU = "res://active-partials/interface/in-game-menu_xscn",
	GUI = "res://active-partials/interface/in-game-gui_xscn",
	STAGE = null ## temporarily, pending abstraction
}

var stages = {
	FPO_A = "res://active-partials/environment/FPO_stage_a.xml",
	FPO_B = "res://active-partials/environment/FPO_stage_b.xml"
}

func _ready():
	root = get_node("/root/scene")
	if( root == null ):
		set_process(false)
		return
	else:
		MUI = root.get("MUI")
		set_process(true)

func get_player(root):
	if root.player != null:
		return root.player
	elif stage.player != null:
		return stage.player
	elif stage.body_layer.has_node("robot"):
		return stage.body_layer.has_node("robot")
	else:
		return null

func get_stage(root):
	if( root.stage != null ):
		return root.stage
	elif( root.has_node("stage")):
		return root.get_node("stage")
	else:
		return null
		
func get_menu():
	if( root.menu != null ):
		return root.menu
	elif root.has_node("menu"):
		return root.get_node("menu")
	else:
		menu = load(scenes.MENU).instance()
		root.add_child(menu)
		return menu

func _process(delta):
	if( tick < 300 ):
		tick = tick + 1
		return
	
	tick = 0
	
	if( root == null ) or ( get_tree().get_root().get_child(0) != root ):
		return
	
	if( !is_inside_tree() ):
		return

	if( get_player(root) != player ):
		print( "register player")
		player = get_player(root)
		print(player)
	
	if( get_stage(root) != stage ):
		print("register stage")
		stage = get_stage(root)
		