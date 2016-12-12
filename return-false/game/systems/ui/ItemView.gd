extends VBoxContainer


onready var inventory_wrapper = find_node('items')
onready var item_preview = find_node('item-preview')
onready var item_name = find_node('item-name')
onready var item_desc = find_node('item-desc')
onready var drop_btn = find_node('drop-item')

var active_item
var active_item_idx

func inventory_updated(was_item_added, which_item):
	if was_item_added:
		inventory_wrapper.add_item(which_item.name, which_item.thumbnail, false)
	else:
		clear_item()
		inventory_wrapper.remove_item(active_item_idx)

func inspect_item(index):
	var item_key = inventory_wrapper.get_item_text(index)
	var item = Inventory.get_item_by('name', item_key)
	active_item = item
	active_item_idx = index
	item_name.set_text(item.name)
	item_preview.set_texture(item.image)
	item_desc.set_bbcode(item.description)
	drop_btn.set_disabled(false)
	if !drop_btn.is_connected('pressed', Inventory, 'drop_item'):
		drop_btn.connect('pressed', Inventory, 'drop_item', [item])

func clear_item():
	active_item = null
	item_name.set_text('')
	item_preview.set_texture(null)
	item_desc.set_bbcode('')
	drop_btn.disconnect('pressed', Inventory, 'drop_item')
	drop_btn.set_disabled(true)

func _ready():
	Inventory.connect('update_UI', self, 'inventory_updated')
	inventory_wrapper.connect('item_selected', self, 'inspect_item')
	drop_btn.set_disabled(true)

func mouse_enter():
	Input.set_custom_mouse_cursor(Game.HUD.default_cursor)

func mouse_exit():
	Input.set_custom_mouse_cursor(Game.HUD.walk_cursor)