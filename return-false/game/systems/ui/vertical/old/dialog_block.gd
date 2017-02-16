extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# data struct:
# object/npc name (for label)
# object/npc small portrait
# dialog contents

var block_img
var block_label
var block_text

func init(data):
	for key in data:
		self[key] = data[key]

	if typeof(block_img) == TYPE_STRING:
		find_node('portrait').set_texture(load(block_img))

	find_node('text').set_text(block_text)
	find_node('speaker').set_text(block_label)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
