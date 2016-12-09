# game.gd
# One approach for global vars, not committed to this yet

extends Node

var Player
var Scene
var Floor
var Space
var Nav
var Object_Layer
var View

var last_action = {}
var active_elevator

func clear_last_action():
	last_action = {}
