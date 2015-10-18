# door script

extends Area2D

var new_stage
export(String, FILE) var new_stage_path
export(int) var door_id
var scene
var player

const PLAYER_CLASS = preload("res://active-partials/player/player-k2d.gd")

# member variables here, example:
# var a=2
# var b="textvar"

func _init():
	new_stage_path = "res://active-partials/environment/FPO_stage_a.xml"
	new_stage = load(new_stage_path)


func _ready():
	# Initialization here
	pass
	
#
#func _enter_tree():
#	if( get_tree().get_root().has_node("/root/scene") ):
#		connect("body_enter", self, "_on_body_enter")
#		connect("body_exit", self, "_on_body_exit")
#
func _on_body_enter(body):
	if body extends PLAYER_CLASS:
		player = body
		yield(body, "done_moving")
		
		var bodies = get_overlapping_bodies()
		if( bodies.find( body ) > -1 ):
			#if( pre_enter()):
			use_door()


func pre_enter():
	return true

func _on_body_exit(body):
	pass


func use_door():

	player["path"] = Array()
	
	var p = Timer.new()
	p.set_wait_time(1)
	p.set_one_shot(true)
	add_child(p)
	p.start()
	
	yield(p, "timeout")
	
	scene = get_tree().get_root().get_node("/root/scene")
	#if( has_user_signal("body_enter") and is_connected("body_enter", self, "_on_body_enter") ):
	if is_connected("body_enter", self, "_on_body_enter"):
		disconnect("body_enter", self, "_on_body_enter")
	scene.call_deferred("swap_stage", new_stage)
