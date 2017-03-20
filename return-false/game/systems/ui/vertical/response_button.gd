extends Button

var next_block
var T
var tween_duration = .25
var tween_ease = Tween.EASE_OUT
var tween_trans = Tween.TRANS_QUAD
var tween_delay = 0


func _ready():
	T = Tween.new()
	add_child(T)

func _collapse():
	T.interpolate_property(self, "rect/scale", Vector2(1,1), Vector2(1,0), tween_duration, tween_trans, tween_ease, tween_delay)
	T.start()
	yield(T, 'tween_complete')
	queue_free()
	

func _slide():
	var pos1 = get_pos()
	var pos2 = Vector2(pos1.x, 0)
	T.interpolate_property(self, "rect/pos", pos1, pos2, tween_duration, tween_trans, tween_ease, tween_delay)
	T.start()