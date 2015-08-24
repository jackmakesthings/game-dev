# General interaction-based NPC base
# This is the latest structure/approach in use, as of 8/21.
# Related: message-ui, quest

extends Node2D

# instance-specific vars
export var id = 001
export var label = "Terminal"
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


export var dialog_branches = Array()
export(bool) var has_branches = false

var player_nearby = false

var utils
var data = ResourceLoader.load("res://data/mocks.gd")
var MUI
var body_node
var player
var x
var n

signal player_redirected(successful, expected, actual)



func setup_MUI(portrait_path, label):
	var pic = ImageTexture.new()
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

	var branch_root_text = "Hey, Tr4ce. Anything to report?"
	var options = []
	
	for branch in dialog_branches:
		var response = {}
		response["text"] = branch["label"]
		
	#### this should get refactored into a proper init_branch method
	# either on NPC or MUI (or on Quest/Branch, maybe)
		response["actions"] = [
			{ fn = "clear",
			target = MUI,
			args = []},
			{ fn = "init_branch",
			target = self,
			args = [branch["key"]]}
		]

		options.append(response)
	
	MUI.clear()
	MUI.make_dialogue(n)
	MUI.make_dialogue(branch_root_text)
	MUI.make_responses(options, false);
	MUI.open()


# stub until branches are set up
func init_branch(key):
	MUI.clear()
	MUI.make_dialogue(n)
	MUI.make_dialogue(key)
	MUI.make_close_button()


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
		#yield(self, "player_redirected")
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
	add_child(src)
	setup_MUI("", src["label"])
	
	var pause = wait(0.5)
	add_child(pause)
	pause.start()
	yield(pause, "timeout")
	
	if( dialog_branches.empty() ):
		i_should_go(src)
	else:
		present_conversations(dialog_branches)



# this exists just to be easily overridden
func set_branches():
	dialog_branches.append({ "label" : "My hardware", "key": "hw", "txt": "Your hardware is awesome." })
	dialog_branches.append({ "label" : "My software", "key": "sw", "txt": "Your software needs upgrades." })



func _ready():

	add_user_signal("player_redirected", ["successful", "expected", "actual"])

	utils = get_node("/root/utils")
	data = ResourceLoader.load("res://data/mocks.gd")
	player = get_node("/root/scene").get("player")
	MUI = get_node("/root/scene/message-ui")
	body_node = get_node("body")
	x = get_node("X")
	
	n = MUI.make_formatted_name(label)
	
	add_child(data)
	set_branches()


	body_node.connect("body_enter_shape", self, "_on_body_enter")
	body_node.connect("body_exit_shape", self, "_on_body_exit")

	#if( trigger_mode == TRIGGER_DIRECT ):
	get_node("body/Sprite").connect("pressed", self, "_on_click")
