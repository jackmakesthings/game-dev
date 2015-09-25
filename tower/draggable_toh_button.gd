
extends ColorPickerButton

# member variables here, example:
# var a=2
# var b="textvar"

var disc_id
var game

func _ready():
	game = get_node("/root/Node2D")
	# Initialization here
	pass
	
func can_drop_data(pos, data):
	print( get_position_in_parent() )
	if( get_position_in_parent() > 1 ):
		return false
	return true
#	var stacks = get_parent().get_parent().get_parent()
#	var stack_1 = stacks.get_node("stack_1/peg 1")
#	var stack_2 = stacks.get_node("stack_2/peg 2")
#	var stack_3 = stacks.get_node("stack_3/peg 3")
#	
#	if( stack_2.get_rect().has_point(pos) ):
#		print( "stack 2!")
	
	#if get_node("/root/Node2D/Control/Panel/HBoxContainer").get_rect().has_point(pos):
	#	return true
	
	#return false
	#return ( typeof(data) == TYPE_DICTIONARY && data.has("color"))
	#return true



func drop_data(pos, data):

	data["disc_id"] = disc_id
	data["node"] = self

	#print( get_drag_data() )
	#print( pos )
	#set_pos(pos)
	#print( data )
	
func get_drag_data(pos):

	if( get_position_in_parent() > 1 ):
		if( game.get("wrong_piece_warned") < 3 ):
			game.get_node(game["wrong_piece_warning"]).popup()
			game.set("wrong_piece_warned", game.get("wrong_piece_warned") + 1)
		return null

	var data = { "node" : self, "color": get_color(), "disc_id": disc_id }
	var cpb = ColorPickerButton.new()
	cpb.set_color(data["color"])
	cpb.set_size(get_size())
	set_drag_preview(cpb)
	data["drag_preview"] = cpb
	return data

func _on_focus():
	get_parent().un_deny()

