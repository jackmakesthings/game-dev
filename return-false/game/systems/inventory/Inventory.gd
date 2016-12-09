# Inventory base class
extends Node

const Item = preload("res://systems/inventory/_Item.gd")
const Collectible = preload('res://systems/inventory/CollectibleItem.gd')
var contents = Array()
signal inventory_updated(was_item_added, which_item)
signal update_UI(was_item_added, which_item)

func add_item(item):
	contents.append(item)
#	print(contents)
#	emit_signal("inventory_updated", true, item)
	emit_signal('update_UI', true, item)
		
func add_new_item(item_data):
	var new_item = Item.new(item_data)
	add_item(new_item)

func get_item_by(param, value):
	var found_item = null
	
	for item in self.get_contents():
		if item[param] == value:
			found_item = item
		else:
			continue
	
	return found_item

func get_item(item_id):
	return get_item_by("id", item_id)
	
func has_item(item_id):
	if get_item(item_id):
		return true
	else:
		return false
	
func get_item_names():
	var names = []
	for item in contents:
		names.append(item.name)
	return names	

func get_item_ids():
	var ids = []
	for item in contents:
		ids.append(item.id)
	return ids

func get_contents():
	return contents

func remove_item(item):
	contents.erase(item)
#	emit_signal("inventory_updated", false, item)
	emit_signal('update_UI', false, item)
	
func find_and_remove_item(item_id):
	var item = get_item(item_id)
	remove_item(item)
	
func drop_item(active_item):
	var item_node = Collectible.new()
	item_node.name = active_item.name
	item_node.image = active_item.image
	item_node.thumbnail = active_item.thumbnail
	item_node.set('textures/normal', active_item.thumbnail)
	item_node.desc = active_item.description
	
	Game.Object_Layer.add_child(item_node)
	item_node.set_global_pos(Game.Player.get_global_pos())
	
	call_deferred('remove_item', active_item)

func _ready():
	pass
