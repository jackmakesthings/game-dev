# Approachable

extends Node2D

const PLAYER_CLASS = preload("res://active-partials/player/player-k2d.gd")
export(NodePath) var trigger_node
var player
var player_nearby

func _entered(body):
	pass

func _exited(body):
	pass

func _stopped_nearby(body):
	pass
	
func _stopped_elsewhere(body):
	return

func _on_body_enter(body):
	if( ! body extends PLAYER_CLASS ):
		return
	self.player_nearby = true
	_entered(body)
	
	yield(body, "done_moving")
	if check_for_player() == true:
		_stopped_nearby(body)


func _on_body_exit(body):
	if( ! body extends PLAYER_CLASS ):
		return
	self.player_nearby = false
	_exited(body)
	

func check_for_player():
	self.player_nearby = false
	var nearby_bodies = get_node(trigger_node).get_overlapping_bodies()
	for body in nearby_bodies:
		if body extends PLAYER_CLASS:
			self.player_nearby = true
		else:
			continue
	return self.player_nearby


func _enter_tree():
	get_node(trigger_node).connect("body_enter", self, "_on_body_enter")
	get_node(trigger_node).connect("body_exit", self, "_on_body_exit")

func _exit_tree():
	if( get_node(trigger_node).is_connected("body_enter", self, "_on_body_enter")):
		get_node(trigger_node).disconnect("body_enter", self, "_on_body_enter")
		get_node(trigger_node).disconnect("body_exit", self, "_on_body_exit")
