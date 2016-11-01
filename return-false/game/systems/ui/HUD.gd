# Persistent UI ("HUD") base controls
extends CanvasLayer

onready var upgrade_label = find_node("upgrade_label")
onready var object_popup = find_node("object_popup")

func resources_updated(text):
	if text != null:
		upgrade_label.set_text(str(text))
	else:
		upgrade_label.set_text(str(Upgrades.get_free_chips()))

func _ready():
	resources_updated('ready')
	if Upgrades.has_user_signal('update_UI'):
		Upgrades.connect('update_UI', self, 'resources_updated')


# Object popup - work in progress

func show_object_popup(data):
	object_popup.activate(data)

func _on_btnTake_pressed():
	object_popup.pickup_object()
	
func _on_btnLeave_pressed():
	object_popup.hide()
	print('No thing for you')
