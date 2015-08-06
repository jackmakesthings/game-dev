# utils & helpers

extends Node

export(String, FILE) var file = "res://assets/dialogue-tree-json.txt"

func get_json(file):
	var json = File.new()
	json.open(file, 1)

	var d = {}
	var err = d.parse_json(json.get_as_text())
	if (err!=OK):
		print("error parsing json")
		return {}
	else:
		return d