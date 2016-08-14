# BitGrid - fresh revision!
# Init with rows, cols, and a selection method
extends Node

export(int) var rows
export(int) var cols

var current_bits = []
var target_bits = []
var active_bits = [] setget make_selection


var styled = preload("res://systems/puzzles/bitgrid/v2/stylebox_teal.tres")
var styled2 = preload("res://systems/puzzles/bitgrid/v2/stylebox_orange.tres")
var unstyled = preload("res://systems/puzzles/bitgrid/v2/stylebox_dark_teal.tres")
var unstyled2 = preload("res://systems/puzzles/bitgrid/v2/stylebox_dark_orange.tres")

onready var current_grid = find_node('current')
onready var target_grid = find_node('target')
onready var total = rows * cols


# This can be called during initialization, but after that, its wrapper
# `flip_bit` will generally be used for changing the bit values.

func set_bit(index, group = current_bits, value=0):
	assert(group != null and group.size() >= index)
	group[index] = value
	
func get_bit(index, group):
	assert(group != null and group.size() >= index)
	return group[index]

# This gets overridden to create different game modes
func _selection_from(index):
	return [index]

func make_selection(index):
	# do some magic to populate an array of points on our grid, make them active
	active_bits = _selection_from(index)
	update_ui(current_bits, true)


# This assumes basic click-to-toggle for the whole selection at once;
# support for fancier moves like "rotating" bits will come later.

func make_move(index):
	for bit in active_bits:
		if get_bit(bit, current_bits) == 1:
			current_bits[bit] = 0
		else:
			current_bits[bit] = 1
		update_ui(current_bits, true)


# Note: this builds a half-0, half-1 array every time.
# This can be changed by randomizing the target_bits assignments.
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
		target_btn.set_text(str(target_bits[i]))
		target_btn.set_v_size_flags(3)
		target_btn.set_h_size_flags(3)
		target_btn.set_disabled(true)
		
		current_grid.add_child(puzzle_btn)
		puzzle_btn.set_text(str(current_bits[i]))
		puzzle_btn.set_v_size_flags(3)
		puzzle_btn.set_h_size_flags(3)
		puzzle_btn.connect('mouse_enter', self, 'make_selection', [i])
		puzzle_btn.connect('pressed', self, 'make_move', [i])
#		puzzle_btn.connect('released', self, 'update_ui', [current_bits, true])

	update_ui(target_bits, true)
	update_ui(current_bits, true)
		


func update_ui(group=current_bits, values_changed=false):
	var grid_node = current_grid
	if group == target_bits:
		grid_node = target_grid

	var blocks = grid_node.get_children()

	for j in range(blocks.size()):
		var block = blocks[j]
		
		if values_changed:
			block.set_text(str(group[j]))
			block.update()
		
		if block.is_disabled():
			if block.get_text() == '1':
				block.add_style_override('disabled', unstyled)
			else:
				block.add_style_override('disabled', unstyled2)
		
		if block.get_text() == '1':
			block.add_style_override('normal', unstyled)
			block.add_style_override('hover', styled)
		else:
			block.add_style_override('normal', unstyled2)
			block.add_style_override('hover', styled2)
		

		if j in active_bits:
			
			if block.get_text() == '1':
				block.add_style_override('normal', styled)
				block.add_style_override('hover', styled)
			
			else:
				block.add_style_override('normal', styled2)
				block.add_style_override('hover', styled2)
				
			block.update()

		# var block_val = get_bit(j, group)
		# if j in active_bits:
			
		# 	if block_val == 1:
		# 		block.add_style_override('normal', styled)
		# 		block.add_style_override('hover', styled)
		# 	else:
		# 		block.add_style_override('normal', styled2)
		# 		block.add_style_override('hover', styled2)
				
		# else:
		# 	if block_val == 1:
		# 		block.add_style_override('normal', unstyled)
		# 		block.add_style_override('hover', unstyled)
		# 	else:
		# 		block.add_style_override('normal', unstyled2)
		# 		block.add_style_override('hover', unstyled2)
				


func _ready():
	build_data()
	build_ui()
