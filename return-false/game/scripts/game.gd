# game.gd
# One approach for global vars, not committed to this yet

extends Node

var Player

# todo: refactor these
var Scene
var Floor
var Space
var Object_Layer

var Nav
var View
var MessageUI
var HUD
var SoundPlayer
var MusicPlayer

var last_action = { 'event': null, 'target': null }
var active_elevator

func clear_last_action():
	last_action = { 'event': null, 'target': null }
