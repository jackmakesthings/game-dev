extends "./_SimpleWalker.gd"

func _enter_tree():
	self.camera = find_node('Camera2D')
	self.anim_node = find_node('AnimationPlayer')
	
	anim_node.play('S')
	anim_node.seek(0.0, true)
	anim_node.stop()