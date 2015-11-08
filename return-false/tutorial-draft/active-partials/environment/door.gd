# door script

extends "res://types/approachable.gd"

var new_env
export(String, FILE) var new_env_path
export(int) var door_id
var scene


func _ready():
	#if new_env_path == null:
	#	new_env_path = "res://active-partials/environment/FPO_stage_a.xml"
	new_env = load(new_env_path)


	
func pre_enter():
	return true

func _stopped_elsewhere(body):
	pass

func _stopped_nearby(body):
	use_door(body)


func use_door(body):

	
	body["path"] = Array()
	
	var p = Timer.new()
	p.set_wait_time(1)
	p.set_one_shot(true)
	add_child(p)
	p.start()
	
	yield(p, "timeout")
	
	#scene = get_tree().get_root().get_node("/root/scene")
	scene = get_tree().get_current_scene()


	if is_connected("body_enter", self, "_on_body_enter"):
		disconnect("body_enter", self, "_on_body_enter")

	scene.call_deferred("swap_env", new_env)
