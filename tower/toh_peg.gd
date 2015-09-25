extends VBoxContainer

var game
var move_counter
var wrong_piece_warning
var wrong_stack_warning


var timer

func _init():
	preload("res://draggable_toh_button.gd")

func _ready():
	game = get_node("/root/Node2D")
	move_counter = get_node("/root/Node2D/Control/move_counter")
	wrong_piece_warning = get_node("/root/Node2D/Control/Panel/cant_let_u_do_that_starfox")
	wrong_stack_warning = get_node("/root/Node2D/Control/Panel/not_there_there")
	
	timer = Timer.new()
	timer.set_wait_time(1.5)
	timer.set_one_shot(true)
	game.add_child(timer)
	
	var kids = get_child_count()
	var i = 0
	while i < kids:
		var kid = get_child(i)
		kid.connect("focus_enter", kid, "_on_focus")
		kid.connect("focus_exit", kid, "_on_focus")
		i = i + 1



func get_drag_data(pos):
	un_deny()



func can_drop_data(pos, data):
	if data == null:
		return false
		
	else:
		var rank = data.disc_id
		var current = 1
	
		if( get_child_count() > 1 ):
			#print( get_child(1).get_name() )
			current = self.get_child(1).get("disc_id")
		else:
			current = 1
		
		if not( current <= rank ):
		
			deny()
			return false
		else:
			un_deny()
			return true
		return false
	return false



func drop_data(pos, data):
	if( ! can_drop_data(pos, data) ):
		if( game.get("wrong_stack_warned") < 3 ):
				wrong_stack_warning.popup()
				game.set("wrong_stack_warned", game.get("wrong_stack_warned") + 1)
				
		deny()
		return false
	un_deny()
	var disc = data.node
	var original_parent = disc.get_parent()
	
	disc.get_parent().remove_child(disc)
	var disc2 = disc.duplicate()
	add_child(disc2)
	move_child(disc2, 1)
	
	if( ! original_parent == get_node(".") ):
		var count = game.get("move_count")
		game.set("move_count", count + 1)
		move_counter.set_text("moves: " + str(game.get("move_count")) )

	
func deny():
	get_parent().set_opacity(0.2)
	
func un_deny():
	get_parent().set_opacity(1.0)
	
func _on_mouse_exit():
	un_deny()