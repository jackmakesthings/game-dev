extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func switch_scene():
	get_node("/root/utils").goto_scene("res://main.xml")

func _ready():
	get_tree().set_current_scene(self)
	#var loader = get_node("menu/HBoxContainer/buttons/load")
	#loader.connect("released", self, "switch_scene")
	# Initialization here
	pass


