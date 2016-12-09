# Interactive object prototype -
# uses TextureButton base for easy interactions

extends TextureButton

export(String) var name
export(String) var desc
export(ImageTexture) var image
export(ImageTexture) var thumbnail

var data

func _enter_tree():
	data = { 'name': name, 'id': name, 'description': desc, 'image': image, 'thumbnail': thumbnail, 'node': self }

func _pressed():
	Game.Player.update_path(get_global_pos() + Vector2(0, get_size().y))
	Game.last_action = { 'event': 'pickup', 'target': self }
	yield(Game.Player, 'done_moving')
	if Game.last_action.target != self or Game.last_action.event != 'pickup':
		return
	if Game.get('HUD') and Game.HUD.has_method('show_object_popup'):
		Game.HUD.show_object_popup(data)

func on_pickup():
	Inventory.add_new_item(data)
	hide()
	queue_free()