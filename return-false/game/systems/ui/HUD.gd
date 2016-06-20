# Persistent UI ("HUD") base controls
extends CanvasLayer

onready var upgrade_label = find_node("upgrade_label")

func resources_updated(text):
	if text != null:
		upgrade_label.set_text(str(text))
	else:
		upgrade_label.set_text(str(Upgrades.get_free_chips()))

func _ready():
	resources_updated('ready')
	if Upgrades.has_user_signal('update_UI'):
		Upgrades.connect('update_UI', self, 'resources_updated')