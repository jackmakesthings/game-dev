# Persistent UI ("HUD") base controls
extends CanvasLayer

onready var upgrade_label = find_node("upgrade_label")
onready var object_popup = find_node("object_popup")
onready var inventory_wrapper = find_node('items')
onready var item_preview = find_node('item-preview')
onready var item_name = find_node('item-name')
onready var item_desc = find_node('item-desc')
onready var drop_btn = find_node('drop-item')

var active_item
var active_item_idx

func resources_updated(text):
	if text != null:
		upgrade_label.set_text(str(text))
	else:
		upgrade_label.set_text(str(Upgrades.get_free_chips()))

func inventory_updated(was_item_added, which_item):
	print("inventory_updated signal came in, calling HUD update")

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
	drop_btn.connect('pressed', Inventory, 'drop_item', [item])

func clear_item():
	active_item = null
	item_name.set_text('')
	item_preview.set_texture(null)
	item_desc.set_bbcode('')
	drop_btn.disconnect('pressed', Inventory, 'drop_item')
	drop_btn.set_disabled(true)


func _ready():
	resources_updated('ready')
	if Upgrades.has_user_signal('update_UI'):
		Upgrades.connect('update_UI', self, 'resources_updated')
	
	Inventory.connect('update_UI', self, 'inventory_updated')
	inventory_wrapper.connect('item_selected', self, 'inspect_item')
	drop_btn.set_disabled(true)



# Object popup - work in progress

func show_object_popup(data):
	object_popup.activate(data)

func _on_btnTake_pressed():
	object_popup.pickup_object()
	
func _on_btnLeave_pressed():
	object_popup.hide()
	print('No thing for you')
