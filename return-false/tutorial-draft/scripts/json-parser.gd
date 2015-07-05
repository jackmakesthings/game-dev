extends Node

var file = "res://assets/dialogue-tree-json.txt"

func get_json(file):
	var json = File.new()
	json.open(file, 1)
   #print(json.get_as_text())
	var d = {}
	var err = d.parse_json(json.get_as_text())
	if (err!=OK):
		print("error parsing json")
		return {}
	else:
		print("success!")
		#print( d )
		return d