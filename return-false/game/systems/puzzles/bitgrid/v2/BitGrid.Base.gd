# BitGrid - fresh revision!
# Init with rows, cols, and a selection method
extends Node

export(int) var rows
export(int) var cols

var current_bits = []
var target_bits = []
var active_bits = [] setget make_selection

var button_base = preload("res://systems/puzzles/bitgrid/v2/_BitButton.Base.tscn")

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
		var target_btn = button_base.instance()
		var puzzle_btn = button_base.instance()
		
		target_grid.add_child(target_btn)
		current_grid.add_child(puzzle_btn)
		
		if target_bits[i] == 1:
			target_btn.show_1(false)
			puzzle_btn.show_1(false)
		else:
			target_btn.show_0(false)
			puzzle_btn.show_0(false)
			
		target_btn.set_disabled(true)
#		
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
		var is_active = (active_bits.has(j))
		var block = blocks[j]
			
		if str(group[j]) == '1':
			block.show_1(is_active)
		else:
			block.show_0(is_active)
		
		block.update()

func _ready():
	build_data()
	build_ui()
