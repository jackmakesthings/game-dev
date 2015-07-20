# utils & helpers

extends Node

export(String, FILE) var file = "res://assets/dialogue-tree-json.txt"

var debug = true

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




func dprint(whatever):
	if( debug ):
		print(whatever)




func dprintt(whatever):
	if( debug ):
		printt(whatever)