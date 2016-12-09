extends PopupDialog

var current_trigger

func setup(data):
	print(data)
	if data.has('description'):
		find_node('desc').set_bbcode(data['description'])
	if data.has('image'):
		find_node('image').set_texture(data['image'])
	if data.has('node'):
		self.current_trigger = data['node']
		
func activate(data):
	setup(data)
	popup_centered()
	
func pickup_object():
	if current_trigger.has_method('on_pickup'):
		current_trigger.call('on_pickup')
	hide()
	current_trigger = null