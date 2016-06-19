extends CanvasLayer


onready var upgrade_label = find_node("upgrade_label")

func resources_updated():
	upgrade_label.set_text(str(Upgrades.free_chips))


func _ready():
	resources_updated()
	Upgrades.connect('update_ui', self, 'resources_updated')
