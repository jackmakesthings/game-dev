extends Node2D

var player
var stage
var npc_root
var MUI
var menu

const player_scene = preload("res://active-partials/player/_robot.xml")
const stage_scene = preload("res://active-partials/environment/FPO_stage_a.xml")
const stage2_scene = preload("res://active-partials/environment/FPO_stage_b.xml")
const MUI_scene = preload("res://active-partials/message-ui/MUI_.xscn")

signal scene_changed
signal stage_changed


func swap_scenes(key="stage", new_scene=stage_scene):

	var _replace = get(key)
	var _n = _replace.get_name()
	var _i = _replace.get_position_in_parent()
	
	var _s = new_scene.instance()
	
	_replace.queue_free()
	
	player = player_scene.instance()
	add_child(_s)
	_s.set_name(_n)
	move_child(_s, _i)
	self.set(key, _s)
	stage.get("body_layer").add_child(player)
	stage.set_process_unhandled_input(true)
	get_tree().set_current_scene(get_tree().get_current_scene())	
	emit_signal("scene_changed", new_scene, key)
	
	
func swap_stage(new_stage):
	var _name = stage.get_name()
	var _pos = stage.get_position_in_parent()
	var _player = player
	
	stage.get("body_layer").remove_child(player)
	
	stage.set_process_unhandled_input(false)
	stage.queue_free()
	var _s = new_stage.instance()
	add_child(_s)
	_s.get("body_layer").add_child(player)
	_s.set_name(_name)
	move_child(_s, _pos)
	
	stage = _s
	player = player
	npc_root = stage["body_layer"]
	stage.set_process_unhandled_input(true)
	emit_signal("stage_changed")
	
	

func _on_stage_change():
	#pass
	var qs = get_tree().get_nodes_in_group("active_quests")
	
	#get_tree().call_group(0, "active_quests", "deactivate")
	get_tree().call_group(0, "active_quests", "add_to_group", "tmp_active")
	get_tree().call_group(0, "tmp_active", "deactivate")
	get_tree().call_group(0, "tmp_active", "activate")
	get_tree().call_group(0, "tmp_active", "remove_from_group", "tmp_active")
	get_tree().call_group(0, "active_quests", "attach_branches")
	#var quest_nb = get_node("quests").get_child_count()
	#for n in range(0, (quest_nb - 1)):
	#	get_node("quests").get_child(n).call("refresh")




func _init():

	
	player = player_scene.instance()
	MUI = MUI_scene.instance()
	add_child(MUI)
	move_child(MUI, 0)

	stage = stage2_scene.instance()
	add_child(stage)
	move_child(stage, 1)
	
	if( stage.has_node("nav/floor/bodies") ):
		npc_root = stage.get_node("nav/floor/bodies")
	

func _ready():
	#add_user_signal("stage_changed", [])
	#add_user_signal("scene_changed", [])
	npc_root =  stage.get("body_layer")
	stage.get("body_layer").add_child(player)	
	stage.set_process_unhandled_input(true)
	#get_tree().set_current_scene(get_tree().get_current_scene())