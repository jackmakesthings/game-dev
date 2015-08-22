extends Node2D

# instance-specific vars
export var id = 001
export var label = "Terminal"
export(Texture) var portrait

export(int, "Character", "Complex", "Simple", "Overheard") var npc_type = 0
export(int, "Direct", "Proximity", "Line of sight") var trigger_mode = 0

const T_CHAR = 0
const T_COMPLEX = 1
const T_SIMPLE = 2
const T_OH = 3


const TM_DIRECT = 0
const TM_PROX = 1
const TM_LOS = 2


var dialog_branches = Array()
var has_branches

var utils
var data = ResourceLoader.load("res://data/mocks.gd")
var MUI


func start_interaction():
	print("boop")
	pass


func setup_MUI(portrait_path, label):
	var pic = ImageTexture.new()
	pic.load(portrait_path)
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

func init_branch(key):
	MUI.clear()
	MUI.make_dialogue(key)

### this is probably going away now that we can do it with tiles
func prepare_to_interact(obj):

	# check if the player is overlapping our trigger area
	yield(obj, "done_moving")
	var o = get_node("body").get_overlapping_bodies()
	
	# if the player kept moving, never mind
	if( o.empty() ):
		return
		
	# but if they stopped here...
	elif( o[0] == obj ):
	
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		add_child(t)
		t.start()
		yield(t, "timeout")
		
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
#		
#		
#		
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
	


func _ready():
	utils = get_node("/root/utils")
	data = ResourceLoader.load("res://data/mocks.gd")
	add_child(data)
	
	dialog_branches.append({ "label" : "My hardware", "key": "hw" })
	dialog_branches.append({ "label" : "My software", "key": "sw" })
	#print(dialog_branches)
	
	MUI = get_node("/root/scene/message-ui")
	if( trigger_mode == 1 ):
		get_node("body").connect("body_enter_shape", self, "on_approach")