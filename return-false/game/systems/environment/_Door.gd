# _Door.gd 
# Simple node type for defining a 'portal' between environments
extends Node2D


export(String, FILE) var destination_path
export(int) var door_id
export(NodePath) var trigger_node

onready var current_scene = get_tree().get_current_scene()
onready var trigger = get_node(trigger_node)

var player_nearby = false
var scene

# Custom methods to be overridden as needed
func _entered(body):
	pass
func _exited(body):
	pass
	
func _stopped_nearby(body):
	use_door(body)
	
func _stopped_elsewhere(body):
	pass


# First, tell the player not to go anywhere.
# Then call the main 'change_scene' method to swap environments.
func use_door(body):
	if body.has_method('update_path'):
		body['path'] = Array()
		scene = get_tree().get_current_scene()
		scene.call('change_scene', destination_path, true)


func _on_body_enter(body):
	if not Utils.is_player(body):
		return

	player_nearby = true
	_entered(body)
	
	yield(body, 'done_moving')
	if Utils.is_player_nearby(trigger):
		_stopped_nearby(body)
	else:
		_stopped_elsewhere(body)


func _on_body_exit(body):
	if not Utils.is_player(body):
		return
	player_nearby = false
	_exited(body)

func _enter_tree():
	add_to_group('doors')
	trigger = get_node(trigger_node)
	trigger.connect('body_enter', self, '_on_body_enter')
	trigger.connect('body_exit', self, '_on_body_exit')

