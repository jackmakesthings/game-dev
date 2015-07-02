extends Node2D

var computerBase
var playerBase

var computer
var player

var gamedata
var savefile = "user://gamedata"

#var MessageTrigger = preload("res://scripts/MessageTrigger.gd");

func _input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		var begin = player.get_pos()
		var end = ev.pos
		print(begin,end)
		
		player.move_to(end)
		#save_data()
		## - get_pos()    # convert our endpoint to be relative from start point
		#player.update_path(begin, end)
	pass

func setup_player():
	player = playerBase.instance()
	player.set_name("Trace")
	#player.set("transform/pos", Vector2(50,100))
	get_node(".").add_child(player)
	player = player.get_child(0)
	return player

func setup_computer():
	computer = computerBase.instance()
	computer.set("name", "Terminal")
	computer.set("message", "beep boop")
	computer.set("transform/pos", Vector2(100,200))
	get_node(".").add_child(computer)
	return computer

#func _init():


func _ready():
	playerBase = ResourceLoader.load("res://scenes/robot.xml")
	computerBase = ResourceLoader.load("res://scenes/computer.xml")
	computer = setup_computer()
	player = setup_player()
	
	#player.set_pos(Vector2(300,300))
	set_process_input(true)
	pass
	