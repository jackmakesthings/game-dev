# Inventory item class

extends Node

export(String) var id
export(String) var name
export(String) var description
export(Texture) var image
export(Texture) var thumbnail
export(Array) var effects

func _init(data):
	for prop in data.keys():
		self.set(prop, data[prop])
		
