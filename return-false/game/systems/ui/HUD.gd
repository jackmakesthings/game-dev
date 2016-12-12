# Persistent UI ("HUD") base controls
extends CanvasLayer

onready var upgrade_label = find_node("upgrade_label")
onready var object_popup = find_node("object_popup")

# cursors
var default_cursor = preload('res://assets/temp/ui/cursor.png')
var walk_cursor = preload('res://assets/temp/ui/align-symbol.png')
var inspect_cursor = preload('res://assets/temp/ui/search.png')
var npc_cursor = preload('res://assets/temp/ui/chat.png')
var elevator_cursor = preload('res://assets/temp/ui/up-down.png')

var active_item
var active_item_idx

func resources_updated(text):
	if text != null:
		upgrade_label.set_text(str(text))
	else:
		upgrade_label.set_text(str(Upgrades.get_free_chips()))


func _ready():
	resources_updated('ready')
	if Upgrades.has_user_signal('update_UI'):
		Upgrades.connect('update_UI', self, 'resources_updated')
	
	find_node('Panel-1').connect("mouse_enter", Input, 'set_custom_mouse_cursor', [default_cursor])
	find_node('Panel-1').connect('mouse_exit', Input, 'set_custom_mouse_cursor', [walk_cursor])

# Object popup - work in progress

func show_object_popup(data):
	object_popup.activate(data)

func _on_btnTake_pressed():
	object_popup.pickup_object()
	
func _on_btnLeave_pressed():
	object_popup.hide()
	print('No thing for you')
