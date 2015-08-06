# quest_node_instance.gd
extends Node

var quests
var npcs

func attach_branches(qNode):
	var a = qNode.get_node("actors").get_children()
	for actor in a:
		var actor_ref = actor.get_name()
		if( npcs.has_node( actor_ref )):
			var anode = npcs.get_node( actor_ref )
			var actor_branch = actor.duplicate()
			actor_branch.set_name(qNode.get_name())
			actor_branch.add_to_group(qNode.get_name() + "_branches")
			anode.get_node("branches").add_child(actor_branch)
			actor_branch.get_node("Label").show()
			
	print("Activated quest ", qNode.get_name())
			
func detach_branches(qNode):
	var branch_group_ref = qNode.get_name() + "_branches"
	var branch_group = get_tree().get_nodes_in_group(branch_group_ref)
	for n in branch_group:
		#n.remove_from_group(branch_group_ref)
		n.queue_free()
	print("Deactivated quest ", qNode.get_name())


func activate_quest(quest_id):
	var qNode = quests.get_node(quest_id)
	if( qNode.is_in_group("active_quests") ):
		print("Already active!")
		return
	qNode.add_to_group("active_quests")
	attach_branches(qNode)
	
func deactivate_quest(quest_id):
	var qNode = quests.get_node(quest_id)
	if( not qNode.is_in_group("active_quests") ):
		print("Nothing to deactivate!")
		return
	qNode.remove_from_group("active_quests")
	detach_branches(qNode)

func is_active(quest_id):
	if( quests.get_node(quest_id).is_in_group("active_quests") ):
		return true
	else:
		return false


func _ready():
	quests = get_node("quests")
	npcs = get_node("scene/npcs")
	
	activate_quest("tutorial")
	
	var terminal = npcs.get_node("terminal_1/branches/tutorial")
	print(terminal.text_at_state("20"))
	#activate_quest("sidequest")
	# Initialization here
	pass



# just for the sake of testing
func _on_clickable_pressed():
	if( is_active("tutorial") ):
		deactivate_quest("tutorial")
	else:
		activate_quest("tutorial")
	#pass # replace with function body
