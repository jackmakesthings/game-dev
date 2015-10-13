# General interaction-based NPC base
# This is the latest structure/approach in use, as of 8/21.
# Related: message-ui, quest

extends Node2D

# instance-specific vars
export var id = "character_1"
export(String) var label
export(Texture) var portrait

# npc_type: Is this a person, an object, 
# a simpler object, or just something in the background?
export(int, "Character", "Complex", "Simple", "Overheard") var npc_type = 0

# trigger_mode: How does the player initiate this interaction?
export(int, "Direct", "Proximity", "Line of sight", "Unique") var trigger_mode = 0

# conversation roots
export(String) var greeting = "Hey, Tr4ce. Anything to report?" 
export(String) var fallback_dialogue = "Can this wait? I'm in the middle of some calibrations."


const T_CHAR = 0
const T_COMPLEX = 1
const T_SIMPLE = 2
const T_OH = 3


const TRIGGER_DIRECT = 0
const TRIGGER_PROX = 1
const TRIGGER_LOS = 2
const TRIGGER_UNIQUE = 3


var dialog_branches = []
var has_branches = false
var branch_root_text = greeting
var active_branch
	
var player_nearby = false
var can_interact = true
var is_interacting = false



var game
var utils = preload("res://scripts/utils.gd")
var MUI = preload("res://active-partials/message-ui/message-ui.xml").instance()

var body_node
var player
var quest_loader

var x
var n

signal player_redirected(successful, expected, actual)



func set_MUI_portrait(portrait_path):
	var pic = ImageTexture.new()
	pic.load(portrait_path)
	pic = portrait
	MUI.make_portrait(pic)



func setup_MUI(portrait_path=null, labeltext=""):
	if portrait_path != null:
		set_MUI_portrait(portrait_path)
	
	

# TODO: fix this --------------
#	if labeltext != "":
#		label = labeltext
#		
#	MUI.make_dialogue(n)
#	
#	MUI.make_portrait(null)




func i_should_go():
	MUI.clear()
	MUI.make_dialogue(n)
	MUI.make_dialogue(fallback_dialogue)
	MUI.make_close_button()
	MUI.open()
	
# alias for in-joke name
func decline_conversation():
	i_should_go()


func present_conversations(dialog_branches):	


	var options = []
	
	if( dialog_branches.size() == 1 ):
		var branch = dialog_branches[0]
		init_branch(branch)
		MUI.open()
		return true
	
	elif( dialog_branches.size() > 1 ):
		for branch in dialog_branches:
			var response = {}
			if branch.get("label"):
				response["text"] = branch["label"]
			elif branch.get("Q_ID"):
				response["text"] = branch["Q_ID"]   # just in case
				
			
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
	#MUI.make_dialogue(n)
	

	
	if( branch.text_at_state(s) == null or branch.responses_at_state(s) == null ):
		print("No responses. Awkward.")
		MUI.close()
		return
		
	
	MUI.make_dialogue(branch.text_at_state(s))
	
	for response in branch.responses_at_state(s):
		branch.build_response(response)

		
	quest.connect("quest_completed", self, "flash_popup")


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
			start_interaction()
		else:
			return
			
	else:
		get_tree().set_input_as_handled()
		start_interaction()





func start_interaction():
	setup_MUI(null, label)
	
	var pause = utils.wait(0.5)
	add_child(pause)
	pause.start()
	yield(pause, "timeout")
	
	print(dialog_branches)
	if( dialog_branches.empty() ):
		i_should_go()
	else:
		var branch_1 = dialog_branches[0]
		if( branch_1 == null ):
			MUI.close()
		if( branch_1 != null ):
			var branch_1_quest = branch_1.get("owned_by")
			var branch_1_state = branch_1_quest.get("current_state")
			if( branch_1._at_state(branch_1_state) == null ):
				return
		
		present_conversations(dialog_branches)


func set_branches():

	yield(quest_loader, "quests_loaded")
	var nodes = get_node(".").get_children()
	for n in nodes:
		if ( n.has_method( "_at_state" )):
			dialog_branches.append(n)



func _ready():

	add_user_signal("player_redirected", ["successful", "expected", "actual"])

	utils = get_node("/root/utils")
	game = get_node("/root/game")
	player = get_node("/root/scene").get("player")
	body_node = get_node("body")
	x = get_node("X")

	if( is_inside_tree() ):
		MUI = get_node("/root/scene").get_child(0)
	
	n = MUI.make_formatted_name(label)
	
	body_node.connect("body_enter_shape", self, "_on_body_enter")
	body_node.connect("body_exit_shape", self, "_on_body_exit")

	#if( trigger_mode == TRIGGER_DIRECT ):
	get_node("body/Sprite").connect("pressed", self, "_on_click")
