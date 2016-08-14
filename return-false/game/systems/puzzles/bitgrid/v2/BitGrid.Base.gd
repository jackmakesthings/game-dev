# BitGrid - fresh revision!
# Init with rows, cols, and a selection method
extends Node

export(int) var rows
export(int) var cols

var current_bits = []
var target_bits = []
var active_bits = [] setget make_selection

var unstyled = StyleBoxEmpty.new()
var styled = StyleBoxEmpty.new()

onready var current_grid = find_node('current')
onready var target_grid = find_node('target')
onready var total = rows * cols


# This can be called during initialization, but after that, its wrapper
# `flip_bit` will generally be used for changing the bit values.

func set_bit(index, group = current_bits, value=0):
	assert(group != null and group.size() >= index)
	group[index] = value
	update_ui(group, true)
	
	# update UI here! #

func flip_bit(index, group):
	assert(group[index] != null)
	if group[index] == 1:
		set_bit(index, group, 0)
	else:
		set_bit(index, group, 1)

func get_bit(index, group = current_bits):
	assert(group != null and group.size() >= index)
	return group[index]


func make_selection(index):
	var _selection = [(index - 1),index,(index+1)]
	# do some magic to populate an array of points on our grid, make them active
	active_bits = _selection
	update_ui(current_bits, false)


func build_data():
	target_bits = Array()
	target_bits.resize(total)
	for i in range(total):
		target_bits[i] = i % 2
	target_bits = Utils.shuffle(target_bits)
	
	current_bits = target_bits
		

func build_ui():
	for i in range(rows*cols):
		var target_btn = Button.new()
		var puzzle_btn = Button.new()
		
		target_grid.add_child(target_btn)
		target_btn.set_text(str(get_bit(i, target_bits)))
		target_btn.set_v_size_flags(3)
		target_btn.set_h_size_flags(3)
		target_btn.set_disabled(true)
		
		current_grid.add_child(puzzle_btn)
		puzzle_btn.set_text(str(get_bit(i, current_bits)))
		puzzle_btn.set_v_size_flags(3)
		puzzle_btn.set_h_size_flags(3)
		puzzle_btn.connect('mouse_enter', self, 'make_selection', [i])
		
	update_ui(target_bits, true)
	update_ui(current_bits, true)
		


func update_ui(group=current_bits, values_changed=false):
	var grid_node = current_grid
	if group == 'target_bits':
		grid_node = target_grid

	var blocks = grid_node.get_children()

	for j in range(blocks.size()):
		if values_changed:
				blocks[j].set_text(str(get_bit(j, group)))
		else:
			if j in active_bits:
				blocks[j].add_style_override('normal', styled)
			else:
				blocks[j].add_style_override('normal', unstyled)


func _ready():
	build_data()
	build_ui()
	
	var theme = get_node('Panel').get_theme()
	styled = theme.get_stylebox('focus','Button')
	#styled = theme.get_stylebox('hover', 'Button')