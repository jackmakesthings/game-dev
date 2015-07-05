
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("HBoxContainer/root").set("file", "res://assets/dialogue-tree-json.txt")
	get_node("HBoxContainer/root").kickoff() # Initialization here
	get_node("HBoxContainer/root 2").set("file", "res://assets/dialogue-tree-json-2.txt")
	get_node("HBoxContainer/root 2").kickoff() # Initialization here
	pass


