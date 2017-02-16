extends Node

# get_json(file)
# Load and parse data from a json file (by path)
func get_json(file):
	var src = File.new()
	src.open(file, 1)

	var parsed = parse_json(src.get_as_text())
	return parsed