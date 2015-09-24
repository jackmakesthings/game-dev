# General interaction-based NPC base
# This is the latest structure/approach in use, as of 8/21.
# Related: message-ui, quest

extends Node2D

# instance-specific vars
export var id = 001
export(String) var label
export(Texture) var portrait

# npc_type: Is this a person, an object, 
# a simpler object, or just something in the background?
export(int, "Character", "Complex", "Simple", "Overheard") var npc_type = 0

# trigger_mode: How does the player initiate this interaction?
export(int, "Direct", "Proximity", "Line of sight", "Unique") var trigger_mode = 0

const T_CHAR = 0
const T_COMPLEX = 1
const T_SIMPLE = 2
const T_OH = 3


const TRIGGER_DIRECT = 0
const TRIGGER_PROX = 1
const TRIGGER_LOS = 2
const TRIGGER_UNIQUE = 3


var dialog_branches = []
var has_branches
var branch_root_text = "Hey, Tr4ce. Anything to report?"
	
var player_nearby = false

var game
var utils
var data = load("res://data/mocks.gd")
var MUI
var body_node
var player
var x
var n

signal player_redirected(successful, expected, actual)



func setup_MUI(portrait_path=null, label=""):
	var pic = ImageTexture.new()
	if( portrait_path != null ):
		pic.load(portrait_path)
	
	if not (self.portrait == null):
		pic = self.portrait
	
	if not (self.label == ""):
		label = self.label
	
	MUI.make_portrait(null)
	MUI.make_portrait(pic)
	MUI.make_dialogue(n)



func i_should_go(src):
	var d0 = src["dlg_no_branches"]
	MUI.clear()
	MUI.make_dialogue(n)
	MUI.make_dialogue(d0["text"])
	MUI.make_responses(d0["responses"], false)
	
	MUI.open()


func present_conversations(dialog_branches):	


	var options = []
	
	if( dialog_branches.size() == 1 ):
		var branch = dialog_branches[0]
		init_branch(branch)
		MUI.open()
	
	elif( dialog_branches.size() > 1 ):
		for branch in dialog_branches:
			var response = {}
			if branch.get("label"):
				response["text"] = branch["label"]
			elif branch.get("Q_ID"):
				response["text"] = branch["Q_ID"]
			else:
				return
			
		#### this should get refactored into a proper init_branch method
		# either on NPC or MUI (or on Quest/Branch, maybe)
			response["actions"] = [
				{ fn = "clear",
				target = MUI,
				args = []},
				{ fn = "init_branch",
				target = self,
				args = [branch]}
			]
	
			options.append(response)
			#print(branch)
		
		MUI.clear()
		MUI.make_dialogue(n)
		MUI.make_dialogue(branch_root_text)
		MUI.make_responses(options, false);
		MUI.open()



# stub until branches are set up
func init_branch(branch):
	var quest = branch.owned_by
	var s = quest.get("current_state")

	MUI.clear()
	MUI.make_dialogue(n)
	
	if( branch.text_at_state(s) == null or branch.responses_at_state(s) == null ):
		MUI.close()
		return
	
	MUI.make_dialogue(branch.text_at_state(s))
	for response in branch.responses_at_state(s):
		branch.build_response(response)
	
	
	quest.connect("quest_completed", self, "flash_popup")

	#MUI.make_close_button()
	


func redirect_player(player, destination):
	player.set_fixed_process(false)
	var offset = destination.get_global_pos()
	offset = get_canvas_transform().xform(offset)
	utils.fake_click(offset, 1)
	yield(player, "oriented")
	emit_signal("player_redirected", player_is_nearby(), destination, player.get_global_pos())

func _on_body_enter(body_id, body_obj, body_shape_id, area_shape_id):
	if( body_obj == player ):
		player_nearby = true


func _on_body_exit(body_id, body_obj, body_shape_id, area_shape_id):
	if( body_obj == player ):
		player_nearby = false;


func player_is_nearby():
	return player_nearby


func _on_click():
	player.set("path", Array())
	if( player_is_nearby() == false):
		redirect_player(player, x)
		yield(player, "done_moving")
		
		if( player_is_nearby() == true ):
			get_tree().set_input_as_handled()
			var src = data.NPC_0.new()
			start_interaction(src)
		else:
			return
			
	else:
		get_tree().set_input_as_handled()
		var src = data.NPC_0.new()
		start_interaction(src)



func wait(time):
	var t = Timer.new()
	t.set_one_shot(true)
	t.set_wait_time(time)
	return t
	


func start_interaction(src):
	print(dialog_branches)
	add_child(src)
	setup_MUI(null, src["label"])
	
	var pause = wait(0.5)
	add_child(pause)
	pause.start()
	yield(pause, "timeout")
	
	if( dialog_branches.empty() ):
		i_should_go(src)
	else:
		var branch_1 = dialog_branches[0]
		var branch_1_quest = branch_1.get("owned_by")
		var branch_1_state = branch_1_quest.get("current_state")
		if( branch_1._at_state(branch_1_state) == null ):
			return
		
		present_conversations(dialog_branches)






func _ready():

	add_user_signal("player_redirected", ["successful", "expected", "actual"])

	utils = get_node("/root/utils")
	game = get_node("/root/game")
	data = load("res://data/mocks.gd").new()
	player = get_node("/root/scene").get("player")
	body_node = get_node("body")
	x = get_node("X")
	MUI = preload("res://scripts/message-ui.gd")
	if( is_inside_tree() ):
		MUI = get_node("/root/scene").get_child(0)
	
	n = MUI.make_formatted_name(label)
	
	add_child(data)
	#set_branches()


	body_node.connect("body_enter_shape", self, "_on_body_enter")
	body_node.connect("body_exit_shape", self, "_on_body_exit")

	#if( trigger_mode == TRIGGER_DIRECT ):
	get_node("body/Sprite").connect("pressed", self, "_on_click")
