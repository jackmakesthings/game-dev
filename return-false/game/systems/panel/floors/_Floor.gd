# Floor script
extends Node2D

var theme_music

func _ready():
	Game.Floor = self
	Game.Space = get_child(0)
	Game.Object_Layer = get_node('YSort')