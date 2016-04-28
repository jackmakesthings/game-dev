# Quest base class
extends Node

export(String) var key
export(int) var otherprop

var actors 

func _init(data):
	for prop in data:
		self[prop] = data[prop]
	set_name(self.key)
	

func _find_actors():
	print(self.actors)
	var NPCS = get_tree().get_current_scene().find_node("NPCManager")

	for actor in self.actors:
		var _actor_node = NPCS.get_node(actor)
		if !_actor_node:
			print("can't find node ", actor)
			return
		if _actor_node.is_in_group("actors_" + self.key):
			print("actor ", actor, " is already accounted for")
			return
			
		_actor_node.add_to_group("actors_" + self.key)
		_actor_node.newline()
		_actor_node.append_bbcode("Now enrolled in quest " + self.key)

func _ready():
	if is_inside_tree():
		_find_actors()

#func _find_actors():
#	var _actor_nodes = Array()
#	var npcs = get_tree().get_nodes_in_group("npcs")
#	var npc_names = Array()
#	for npc in npcs:
#		npc_names.append(npc.get_name())
#		
#	var npc_manager = get_tree().get_current_scene().find_node("NPCManager")
#	#print(npcs)
#	if self.actors.size() < 1:
#		return
#	else:
#		for actor in self.actors:
#			if npc_names.find(actor):
#			#if npc_manager.has_node(actor):
#				_actor_nodes.append(get_tree().get_current_scene().find_node(actor))
#	
#	print(_actor_nodes)
#	return _actor_nodes
#
#	
#func _setup_actors():
#	var nodes = _find_actors()
#	print("nodes are ", nodes)
#	for node in nodes:
#		node.append_bbcode(get_name())
#
