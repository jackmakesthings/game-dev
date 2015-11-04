extends Node2D

var player
var stage
var npc_root
var MUI
var menu
var main_menu
var main_menu_open
var ingame_menu_open
var utils
var _

var prev_pos

var fade_anim
var fade_screen

var canv

const player_scene = preload("res://active-partials/player/_robot.xml")
const stage_scene = preload("res://active-partials/environment/FPO_stage_a.xml")
const stage2_scene = preload("res://active-partials/environment/FPO_stage_b.xml")
const MUI_scene = preload("res://active-partials/message-ui/MUI_.xscn")
const ingame_menu_scene = preload("res://active-partials/interface/in-game-menu_.xscn")
#const main_menu_scene = preload("res://active-partials/interface/game-menu_.xml")

var main_menu_scene = "res://active-partials/interface/game-menu_.xml"

#signal scene_changed(new_scene, key)
signal stage_changed(stage)


func swap_stage(new_stage):

	prev_pos = player.get_pos()
	fade_screen.set("z/z", 10)
	fade_anim.play("fade_out")
	yield(fade_anim, "finished")
	call_deferred("_swap_stage", new_stage)
	
	
func _swap_stage(new_stage):

	var _name = stage.get_name()
	var _pos = stage.get_position_in_parent()
	var _player = player
	
	stage.get("body_layer").remove_child(player)
	
	stage.set_process_unhandled_input(false)
	stage.queue_free()
	var _s = new_stage.instance()
	add_child(_s)
	_s.get("body_layer").add_child(player)
	_s.set_name("stage")
	move_child(_s, _pos)
	
	stage = _s
	player = player
	player.set_pos(prev_pos)
	npc_root = stage["body_layer"]
	stage.set_process_unhandled_input(true)

	emit_signal("stage_changed", stage)
	
	

func _on_stage_change(stage):
	
	var qs = get_tree().get_nodes_in_group("active_quests")
	get_tree().call_group(0, "active_quests", "refresh")
	get_tree().call_group(0, "npcs", "set_paths")

	call_deferred("fade_in")
	
	
	

func fade_in():
	fade_anim.play("fade_in")
	yield(fade_anim, "finished")
	fade_screen.set("z/z", 0)
	
func show_main_menu():
	#add_child(main_menu)
	#get_tree().set_current_scene(main_menu)
	get_tree().set_pause(true)
	main_menu = main_menu_scene.instance()
	canv = CanvasLayer.new()
	add_child(canv)
	canv.set_layer(3)
	canv.add_child(main_menu)
	canv.raise()
	main_menu_open = true



func hide_main_menu():
	get_tree().set_pause(false)
	if( canv != null ):
		canv.set_layer(-1)
		
	
		canv.queue_free()
		
		if( menu != null ):
			menu.hide_menu()

		main_menu_open = false
	get_tree().set_pause(false)
		
		
		
func on_menu_toggle(state):
	ingame_menu_open = state
	get_tree().set_pause(state)


func _init():

	player = player_scene.instance()
	MUI = MUI_scene.instance()
	menu = ingame_menu_scene.instance()

	add_child(menu)
	move_child(menu, 0)
	#menu.connect("menu_opened", self, "on_menu_toggle", [true])
	#menu.connect("menu_closed", self, "on_menu_toggle", [false])
	
	add_child(MUI)
	move_child(MUI, 0)
	
	stage = stage_scene.instance()
	add_child(stage)
	stage.set_name("stage")
	move_child(stage, 1)
	
	if stage.get("body_layer"):
		npc_root = stage.get("body_layer")
	elif stage.has_node("nav/floor/bodies"):
		npc_root = stage.get_node("nav/floor/bodies")
	
	

		
	add_user_signal("stage_changed", ["stage"])



func _ready():
	_ = get_node("/root/_")
	
	fade_anim = get_node("AnimationPlayer")
	fade_screen = get_node("fader")
	
	npc_root =  stage.get("body_layer")
	npc_root.add_child(player)
	
	_.player = player
	_.stage = stage
	_.MUI = MUI
	
	stage.set_process_unhandled_input(true)
	get_tree().set_current_scene(get_tree().get_current_scene())
	
	main_menu_scene = preload("res://active-partials/interface/game-menu_.xml")

#	
#	if get_tree().get_root().has_node("scene/AnimationPlayer"):
#		fade_anim = get_tree().get_root().get_node("scene/AnimationPlayer")
#
