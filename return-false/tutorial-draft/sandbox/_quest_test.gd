extends "res://sandbox/_quest.gd"

var Q_ID = "test"
var actors = ["grace", "ada"]
var data_source = "res://sandbox/_quest_data.gd"

func _ready():
	_setup()
	_test()