# Interactive object prototype -
# uses TextureButton base for easy interactions

extends TextureButton

export(String) var name
export(String) var desc
export(ImageTexture) var image

func _pressed():
	var data = { 'name': name, 'desc': desc, 'image': image, 'node': self }
	var game = get_tree().get_current_scene()
	if game.get('HUD') and game.HUD.has_method('show_object_popup'):
		game.HUD.show_object_popup(data)

func on_pickup():
	hide()
	queue_free()