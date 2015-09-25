
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

export(int) var move_count


export(int) var wrong_piece_warned
export(int) var wrong_stack_warned

export(NodePath) var wrong_piece_warning
export(NodePath) var wrong_stack_warning

func _ready():
	move_count = 0
	wrong_piece_warned = 0
	wrong_stack_warned = 0

