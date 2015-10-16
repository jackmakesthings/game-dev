extends Node2D

var player
var stage
var npc_root
var MUI
var menu
var utils

var prev_pos

var fade_anim
var fade_screen

const player_scene = preload("res://active-partials/player/_robot.xml")
const stage_scene = preload("res://active-partials/environment/FPO_stage_a.xml")
const stage2_scene = preload("res://active-partials/environment/FPO_stage_b.xml")
const MUI_scene = preload("res://active-partials/message-ui/MUI_.xscn")

#signal scene_changed(new_scene, key)
signal stage_changed(stage)


func swap_stage(new_stage):
	#var transform = get_viewport_transform().affine_inverse().xform( ev.global_pos )

	#player.get_node("Camera2D")
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
	call_deferred("fade_in")
	
	
	

func fade_in():
	fade_anim.play("fade_in")
	yield(fade_anim, "finished")
	fade_screen.set("z/z", 0)
	
	
	



func _init():
	
	player = player_scene.instance()
	MUI = MUI_scene.instance()
	
	add_child(MUI)
	move_child(MUI, 0)
	
	stage = stage2_scene.instance()
	add_child(stage)
	stage.set_name("stage")
	move_child(stage, 1)
	
	if( stage.has_node("nav/floor/bodies") ):
		npc_root = stage.get_node("nav/floor/bodies")
		

		
	add_user_signal("stage_changed", ["stage"])
#	add_user_signal("scene_changed", ["new_scene", "key"])



func _ready():
	
	fade_anim = get_node("AnimationPlayer")
	fade_screen = get_node("fader")
	npc_root =  stage.get("body_layer")
	stage.get("body_layer").add_child(player)
	stage.set_process_unhandled_input(true)
	get_tree().set_current_scene(get_tree().get_current_scene())
	
	if get_tree().get_root().has_node("scene/AnimationPlayer"):
		fade_anim = get_tree().get_root().get_node("scene/AnimationPlayer")

