# Simple "door" button for going left/right between rooms

extends BaseButton
export(NodePath) var target_room

var tween
var t

var direction # 1 = right, -1 = left
var offset_size # how far to walk thru
var door_y = 600 # vertical position to walk thru

func _ready():
	
	# door target areas are only visible while editing
	set_self_opacity(0.0)
	
	if tween == null:
		tween = Tween.new()
		add_child(tween)
	if t == null:
		t = Timer.new()
		t.set_one_shot(true)
		add_child(t)

	var pos = get_global_pos()
	var target_pos = get_node(target_room).get_global_pos()

	if pos.x < target_pos.x:
		direction = 1
	else:
		direction = -1
	offset_size = 400*direction

func _pressed():
	slide_camera()

func slide_camera():
	# Establish where we are and where we're going
	var current_left = Game.Player.camera.get('limit/left')
	var current_right = Game.Player.camera.get('limit/right')
	var target_left = get_node(target_room).get_global_pos().x
	var target_right = target_left + get_node(target_room).get_item_rect().size.x

	# Walk the player past the door
	if direction > 0:
		Game.Player.update_path(Vector2(target_left, door_y))
	else:
		Game.Player.update_path(Vector2(target_right, door_y))

	Game.last_action = { 'event': 'door', 'target': self }
	
	yield(Game.Player, 'done_moving')
	# Make sure the player didn't change their mind on the way
	if Game.last_action.event != 'door':
		return

	# Hide them so they're not visible during the camera tween
	Game.Player.hide()

	# Tween the camera over to the new room, pause briefly
	tween.interpolate_property(Game.Player.camera, 'limit/left', current_left, target_left, 0.65, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	tween.interpolate_property(Game.Player.camera, 'limit/right', current_right, target_right, 0.65, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	tween.start()
	yield(tween, 'tween_complete')
	t.set_wait_time(0.75)
	t.start()
	yield(t, 'timeout')


	# Show the player and walk them further into the room
	Game.Player.show()
	Game.Player.update_path(Game.Player.get_global_pos() + Vector2(offset_size, 0))
	Game.Space = get_node(target_room)