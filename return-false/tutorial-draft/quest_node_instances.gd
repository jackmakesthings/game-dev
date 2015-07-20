
extends Node

var quests
var npcs = Node.new()

func attach_branches(q):
	var a = q.get_node("actors").get_children()
	for actor in a:
		var actor_ref = actor.get_name()
		if( npcs.has_node( actor_ref )):
			var anode = npcs.get_node( actor_ref )
			var actor_branch = actor.duplicate()
			actor_branch.set_name(q.get_name())
			actor_branch.add_to_group(q.get_name() + "_branches")
			anode.get_node("branches").add_child(actor_branch)
			actor_branch.get_node("Label").show()
			
	print("Activated quest ", q.get_name())	
			
func detach_branches(q):
	var branch_group_ref = q.get_name() + "_branches"
	var branch_group = get_tree().get_nodes_in_group(branch_group_ref)
	for n in branch_group:
		n.queue_free()
	print("Deactivated quest ", q.get_name())


func activate_quest(quest_id):
	var q = quests.get_node(quest_id)
	q.add_to_group("active_quests")
	attach_branches(q)
	
func deactivate_quest(quest_id):
	var q = quests.get_node(quest_id)
	q.remove_from_group("active_quests")
	detach_branches(q)



func _ready():
	quests = get_node("quests")
	npcs = get_node("scene/npcs")
	
	activate_quest("tutorial")
	activate_quest("sidequest")
	# Initialization here
	pass


