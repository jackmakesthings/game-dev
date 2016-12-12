extends Panel

onready var map_img = find_node('map-img')
onready var player_sprite = find_node('map-player')

var ppos
var scale_from
var scale_to
var scale_ratio
var map_mid_y
var sprite_y

func _ready():

	ppos = Game.Player.get_global_pos().x
	scale_from = Game.Floor.get_item_and_children_rect().size.x
	scale_to = map_img.get_size().x
	scale_ratio = scale_to / scale_from
	map_mid_y = map_img.get_size().y / 2
	sprite_y = player_sprite.get_pos().y
	
	set_fixed_process(true)
	
#	Game.Player.connect('done_moving', self, '_update_view')

func _update_view():
	var scaled_pos = Game.Player.get_global_pos().x * scale_ratio
	player_sprite.set_pos(Vector2(scaled_pos, sprite_y))
	
func _fixed_process(delta):
	if Game.Player.is_moving:
		_update_view()
		
func mouse_enter():
	Input.set_custom_mouse_cursor(Game.HUD.default_cursor)
