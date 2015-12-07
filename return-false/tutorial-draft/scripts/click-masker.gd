# Automatic click mask setter based on alpha
# Use for texture buttons with non-solid shapes
# (including NPC "sprite" texture buttons)
extends TextureButton

func _ready():

	var image = Image()
	var current_t = get_normal_texture().get_path()
	image.load(current_t)
	
	#create a new bitmap from the alpha channel
	var bitMap = BitMap.new()
	bitMap.create_from_image_alpha(image)
  
	#assign the bitmap to the click mask
	set_click_mask(bitMap)
  