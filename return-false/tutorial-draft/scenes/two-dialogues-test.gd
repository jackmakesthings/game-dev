
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var terminal
var cabinet
var engineer

func _ready():
	var terminal = get_node("HBoxContainer/root")
	var cabinet = get_node("HBoxContainer/root 2")
	
	terminal.set("file", "res://assets/dialogue-tree-json.txt")
	terminal.get_node("Control/Button").set_text("TERMINAL")
	terminal.get_data() # Initialization here
	
	
	cabinet.set("file", "res://assets/cabinet-tree.txt")
	cabinet.get_node("Control/Button").set_text("CABINET")
	cabinet.get_data() # Initialization here
	pass


