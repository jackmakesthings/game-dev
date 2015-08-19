extends Node2D

var player



func _enter_tree():
	player = get_node("stage/nav/floor/bodies/robot")