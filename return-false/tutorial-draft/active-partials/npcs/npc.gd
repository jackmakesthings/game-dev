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

var utils
var data = ResourceLoader.load("res://data/mocks.gd")
var MUI
var body_node
var player
var x


func start_interaction():
	print("boop")
	pass


func setup_MUI(portrait_path, label):
	var pic = ImageTexture.new()
	pic.load(portrait_path)
	
	if not (portrait == null):
		pic = portrait
	
	if not (self.label == ""):
		label = self.label
		
	MUI.make_portrait(pic)
	MUI.make_formatted_name(label)


func i_should_go(dlg):
	var d0 = dlg["dlg_no_branches"]
	MUI.clear()
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
			{
			fn = "clear",
			target = MUI,
			args = []
			},
			{
		#	fn = "make_dialogue",
		#	target = MUI,
		#	args = [branch["key"]]
			fn = "init_branch",
			target = self,
			args = [branch["key"]]
		}]
		options.append(response)
	
	MUI.clear()
	MUI.make_dialogue(branch_root_text)
	MUI.make_responses(options, false);
	MUI.open()


# stub until branches are set up
func init_branch(key):
	MUI.clear()
	MUI.make_dialogue(key)
	MUI.make_close_button()
	

func bring_to(obj, x):
	var offset = x.get_global_pos()
	offset = get_canvas_transform().xform(offset)
	#player.update_path(player.get_global_pos(), offset, player["nav"])
	
	
	var ev = InputEvent()
	ev.type = InputEvent.MOUSE_BUTTON
	# button_index is only available for the above type
	ev.button_index=BUTTON_LEFT
	ev.pressed = true
	ev.global_pos = offset
	get_tree().input_event(ev)
	
func hold(t, time):
	t.set_wait_time(time)
	t.set_one_shot(true)
	add_child(t)
	t.start()

### this is probably going away now that we can do it with tiles
func prepare_to_interact(obj):
	var o
	# check if the player is overlapping our trigger area
	if( obj["is_moving"] == true ):
		yield(obj, "done_moving")
		o = body_node.get_overlapping_bodies()
	
	else:
		o = body_node.get_overlapping_bodies()
	
	# if the player kept moving, never mind
	if( o.empty() ):
		if( trigger_mode == TRIGGER_DIRECT ):
		
			bring_to(obj, x)
					
					
			yield(obj, "done_moving")
			
			var t = Timer.new()
			hold(t, 0.2)
			yield(t, "timeout")	
			
			if(npc_type == T_CHAR):
			
				var dlg = data.NPC_0.new()
				add_child(dlg)
				setup_MUI(dlg["portrait_path"], dlg["label"])
				
				
				if( dialog_branches.empty() ):
					i_should_go(dlg)
				else:
					present_conversations(dialog_branches)

		
		elif( trigger_mode == TRIGGER_PROX ):
			return

		
	# but if they stopped here...
	elif( o[0] == obj ):
	
		
		if(npc_type == T_CHAR):
		
			var dlg = data.NPC_0.new()
			add_child(dlg)
			setup_MUI(dlg["portrait_path"], dlg["label"])
			
			
			if( dialog_branches.empty() ):
				i_should_go(dlg)
			else:
				present_conversations(dialog_branches)
			
			
#		var obj_pos = obj.get_pos()
#		var self_pos = get_pos()
#		var angle = rad2deg(obj_pos.angle_to_point(self_pos)) 
#		var dir_to_face = utils.angle_to_compass(angle)
#		reorient(obj, dir_to_face)


func reorient(node, towards):
	node.orient(towards)


func on_approach(body_id, body_obj, body_shape_id, area_shape_id):
	# triggered by the player?
	if( not body_obj extends KinematicBody2D ):
		return
	prepare_to_interact(body_obj)
	#print("Body id: ", body_id)
	#print("Body object: ", body_obj)
	#print("Body shape: ", body_shape_id)
	#print("Area shape: ", area_shape_id)


func on_click(player_obj):
	var o = body_node.get_overlapping_bodies()
	if( o.find(player_obj) ):
		get_tree().set_input_as_handled()
		prepare_to_interact(player_obj)


# this exists just to be easily overridden
func set_branches():
	dialog_branches.append({ "label" : "My hardware", "key": "hw", "txt": "Your hardware is awesome." })
	dialog_branches.append({ "label" : "My software", "key": "sw", "txt": "Your software needs upgrades." })

func _ready():
	utils = get_node("/root/utils")
	data = ResourceLoader.load("res://data/mocks.gd")
	player = get_node("/root/scene").get("player")
	body_node = get_node("body")
	x = get_node("X")
	
	add_child(data)
	set_branches()
	MUI = get_node("/root/scene/message-ui")
	if( trigger_mode == TRIGGER_DIRECT ):
		get_node("body/Sprite").connect("pressed", self, "on_click", [player])
	#elif( trigger_mode == TRIGGER_PROX ):
	#	get_node("body/Sprite").connect("pressed", self, "on_click", [player])
	#	get_node("body").connect("body_enter_shape", self, "on_approach")