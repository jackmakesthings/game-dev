#extends "res://active-partials/npcs/base_npc.gd"

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


var dialog_branches = []
var has_branches

var utils
var M
var MUI


func start_interaction():
	print("boop")
	pass

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
			#MUI = preload("res://active-partials/message-ui/message-ui.xml").instance()

			
			if( dialog_branches.empty() ):
			
				var dlg_0 
				
				#print(M.get_method_list())
			
				MUI.open()
			#	MUI.make_dialogue(dlg_0["text"])
			#	MUI.make_response(dlg_0["responses"])
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
	# triggering or just colliding with?
	#if( area_shape_id == 0 ):
	#	return

	prepare_to_interact(body_obj)
	
	
	
	
		#print("Body id: ", body_id)
	#print("Body object: ", body_obj)
	#print("Body shape: ", body_shape_id)
	#print("Area shape: ", area_shape_id)
	
	
	#pass


func _ready():
	utils = get_node("/root/utils")
	M = get_node("/root/mocks").new()
	
	
	MUI = get_node("/root/scene/message-ui")
	if( trigger_mode == 1 ):
		get_node("body").connect("body_enter_shape", self, "on_approach")


	
# just wanted to try this, it works!
#export(NodePath) var quest_node
