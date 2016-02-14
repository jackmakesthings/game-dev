extends Node2D

var player
var env
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
const env_1_scene = preload("res://active-partials/environment/FPO_stage_a.xml")
const env_2_scene = preload("res://active-partials/environment/FPO_stage_b.xml")
const env_3_scene = preload("res://active-partials/environment/FPO_stage_c.xml")
const MUI_scene = preload("res://active-partials/message-ui/MUI_.xscn")
const ingame_menu_scene = preload("res://active-partials/interface/in-game-menu_.xml")
const main_menu_scene = preload("res://active-partials/interface/game-menu_.xml")


signal env_changed(env)


func swap_env(new_env):

	prev_pos = player.get_pos()
	fade_screen.set("z/z", 10)
	fade_anim.play("fade_out")
	yield(fade_anim, "finished")
	call_deferred("simple_swap_env", new_env)
	


func simple_swap_env(new_env):
	
	var _pos = env.get_position_in_parent()
		
	env.set_process_unhandled_input(false)
	env.set_name("_env")
	env.free()
	
	var _env = new_env.instance()
	
	add_child(_env)
	_env.set_name("env")
	move_child(_env, _pos)
	
	env = _env
	player = env.find_node("robot")
	
	emit_signal("env_changed", env)


func _on_env_change(env):
	
	get_tree().call_group(0, "active_quests", "refresh")
	get_tree().call_group(0, "npcs", "set_paths")
	call_deferred("fade_in")


func fade_in():
	fade_anim.play("fade_in")
	yield(fade_anim, "finished")
	fade_screen.set("z/z", 0)
	env.set_process_unhandled_input(true)


func show_main_menu():
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


func create_instances():
	player = player_scene.instance()
	MUI = MUI_scene.instance()
	menu = ingame_menu_scene.instance()

	add_child(menu)
	move_child(menu, 0)

	add_child(MUI)
	move_child(MUI, 0)



func create_env(base):
	env = base.instance()
	add_child(env)
	env.set_name("env")
	move_child(env, 1)
	

func _init():
	create_instances()
	create_env(env_3_scene)
	add_user_signal("env_changed", ["env"])


func set_internals():
	fade_anim = get_node("AnimationPlayer")
	fade_screen = get_node("fader")


func set_externals():
	_ = get_node("/root/_")


func update_registry(params):
	for param in params:
		_.set(param, self[param])


func _ready():

	set_internals()
	set_externals()
	update_registry(["player", "env", "MUI"])
	

	env.set_process_unhandled_input(true)
	get_tree().set_current_scene(get_tree().get_current_scene())

