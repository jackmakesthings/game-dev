
extends Node

# member variables here, example:
# var a=2
# var b="textvar"
var quests = ["Tutorial", "Sidequest", "Later sidequest"]
var quest_holder 

func debug_quests():
	var qqstr = "All quests: "
	var aqstr = "Active quests: "
	var qq = get_tree().get_nodes_in_group("all_quests")
	for q in qq:
		qqstr = qqstr + q.get_name()
		q.set("custom_colors/font_color", "#000000")
		#q.set("flat", true)
	var aq = get_tree().get_nodes_in_group("active_quests")
	for a in aq:
		aqstr = aqstr + a.get_name()
		a.set("custom_colors/font_color", "#00ccdd")
		#a.set("flat", false)
	
	print(qqstr)
	print(aqstr)
	#var iq = get_tree().get_nodes_in_group("inactive_quests")

func init_quests():
	for q in quests:
		var qLabel = Button.new()
		qLabel.set_text(q)
		qLabel.set_name(q)
		qLabel.set("flat", true)
		qLabel.set_v_size_flags(2)
		qLabel.set_h_size_flags(2)
		qLabel.add_to_group("all_quests")
		qLabel.set("state", "0")
		qLabel.connect("pressed", self, "on_button_pressed", [q])
		quest_holder.add_child(qLabel)

func update_quest(state, quest):
	var qnode = quest_holder.get_node(quest)
	qnode.set("state", state)

func init_debugger():
	var db = Button.new()
	db.set_name("debugger")
	db.set_text("Check quest flags")
	db.set_v_size_flags(2)
	db.set_v_size_flags(2)
	db.connect("pressed", self, "debug_quests")
	quest_holder.add_child(db)

func activate_quest(quest):
	var n = quest_holder.get_node(quest)
	n.add_to_group("active_quests")
	print("Quest ", quest, " is now active")
	
func deactivate_quest(quest):
	var n = quest_holder.get_node(quest)
	n.remove_from_group("active_quests")
	print("Quest ", quest, " is now inactive")

func on_button_pressed(quest):
	var n = quest_holder.get_node(quest)
	if( n.is_in_group("active_quests") ):
		deactivate_quest(quest)
	else:
		activate_quest(quest)
	debug_quests()

func _ready():
	quest_holder = get_node("quests")
	# Initialization here
	init_quests()
	#init_debugger()
	#debug_quests()
	pass


