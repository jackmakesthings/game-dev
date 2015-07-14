extends Node2D

var computerBase
var playerBase

var computer
var player

var quest

var nav = "/root/game/Navigation2D"

var messageNode

var dialogues_allowed = false

var which

var gamedata
var savefile = "user://gamedata"

#var MessageTrigger = preload("res://scripts/MessageTrigger.gd");

func _input(ev):
	if (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index==1):
		var begin = player.get_global_pos()
		var end = ev.global_pos
		
		player.update_path(begin, end);
		yield(player, "done_moving")
		allow_dialogues()
	pass

func allow_dialogues():
	dialogues_allowed = true

func setup_player():
	#var playerInst = playerBase.instance()
	player = get_node("Navigation2D/YSort/robot")
	player.set_name("Trace")
	return player

func setup_computer():
	#computer = computerBase.instance()
	computer = get_node("Navigation2D/YSort/computer-base")
	computer.set("name", "Terminal")
	computer.set("message", "beep boop")
	#computer = get_node(".").add_child(computer)
	return computer

func update_labels():
	pass
#	var e_dialog = fsm.get("engineer")["dialog"]
#	var c_dialog = fsm.get("cabinet")["dialog"]
#	var t_dialog = fsm.get("terminal")["dialog"]
#	var m = messageNode
#	
#	
#	m.clear()
#	m.add_text("Engineer: " + str(e_dialog))
#	m.newline()
#	m.add_text("Cabinet: " + str(c_dialog))
#	m.newline()
#	m.add_text("Terminal: "+ str(t_dialog))


func update_label(which):
	pass
	#var dialog = fsm.get(which)["dialog"]
	#var m = messageNode
	
	#m.clear()
	#m.add_text(str(dialog))

	

func _ready():
	quest = get_node("quest")
	
	messageNode = get_node("RichTextLabel")
	
	# computer = setup_computer()
	#player = setup_player()
	player = get_node("Navigation2D/YSort/robot")
	
	#player.set_pos(Vector2(300,300))
	set_process_input(true)
	
	#get_node("terminal").connect("body_enter", self, "_on_terminal_body_enter")
	#get_node("cabinet").connect("body_enter", self, "_on_cabinet_body_enter")
	#get_node("engineer").connect("body_enter", self, "_on_engineer_body_enter")	
	
	#get_node("terminal").connect("body_exit", self, "_on_Area2D_body_exit")
	#get_node("cabinet").connect("body_exit", self, "_on_Area2D_body_exit")
	#get_node("engineer").connect("body_exit", self, "_on_Area2D_body_exit")	
	
	pass
	
func _on_terminal_body_enter(body):
	if( body.get_name() == "Trace" ):
		which = "terminal"
		update_label("terminal")
		var dialogues = get_node("/root/utils").get_json("res://assets/dialogue-tree-json.txt")
		printt(dialogues["20"]["dialogue"])

func _on_cabinet_body_enter(body):
	if( body.get_name() == "Trace" ):
		which = "cabinet"
		update_label("cabinet")

func _on_engineer_body_enter(body):
	if( body.get_name() == "Trace" ):
		which = "engineer"
		update_label("engineer")


func _on_Area2D_body_exit( body ):
	messageNode.clear()
	pass # replace with function body


