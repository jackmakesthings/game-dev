# BitGrid

extends Node

export(int) var cols
export(int) var rows

export(int) var shuffle_count


var selection_mode = 1

var active_group = []

var _bits = []
var target_bits
var current_bits

onready var target_grid = find_node('target')
onready var puzzle_grid = find_node('puzzle')
onready var total = cols * rows
onready var seeds = range(total - 1)


# Utilities

func is_solved():
	return (current_bits == target_bits)

func get_opposite(bit):
	if str(bit) == '0':
		return 1
	return 0

# Returns a shuffled copy of an array
func shuffle(array):
	var new_array = Array()
	new_array.resize(array.size())
	for i in range(1, new_array.size()):
		randomize()
		var j = floor(randf() * (i + 1))
		var temp = array[i]
		new_array[i] = array[j]
		new_array[j] = temp
	return new_array	



func i_to_n(bit_array, grid=puzzle_grid):
	var nodes = []
	for i in bit_array:
		nodes.append(grid.get_child(i))
	return nodes

func n_to_i(node_array, grid=puzzle_grid):
	var indices = []
	for i in node_array:
		indices.append(i.get_index())
	return indices	

# Grid UI generation

# TODO: replace with theming
func style_btn(btn):
	btn.set_h_size_flags(3)
	btn.set_h_size_flags(3)
	return btn

func make_btn(text):
	var _btn = Button.new()
	_btn = style_btn(_btn)
	_btn.set_text(str(text))
	return _btn


# Flipping

func flip(bit):
	var bit_node
	
	if typeof(bit) == TYPE_INT:
		bit_node = puzzle_grid.get_child(bit)
	
	# we may need to convert a passed-in node to an index
	# this needs to be cleaned up, i think
	else:
		bit_node = bit
		bit = bit.get_index()
		
	var _val = get_opposite(bit_node.get_text())

	current_bits[bit] = _val
	bit_node.set_text(str(_val))

func flip_group(group=active_group):
	for bit in group:
		flip(bit)
	if is_solved():
		end_game()



## Minigame setup

func init_bits():
	for i in range(0, cols*rows):
		randomize()
		if randi() % 2 == 0:
			_bits.append(0)
		else:
			_bits.append(1)


func init_target():
	target_grid.set_columns(cols)
	# add a little more randomness, why not eh
	target_bits = shuffle(_bits)
	for bit in target_bits:
		var _btn = make_btn(bit)
		target_grid.add_child(_btn)
		_btn.set_disabled(true)

func init_puzzle():
	puzzle_grid.set_columns(cols)
	print("target bits: ", target_bits)
	current_bits = scramble_bits(target_bits)
	#current_bits = target_bits
	for bit in current_bits:
		var _btn = make_btn(bit)
		puzzle_grid.add_child(_btn)
		_btn.connect('pressed', self, 'flip_group', [], 1)
		_btn.connect('mouse_enter', self, 'highlight_by', [_btn, 1])


# This is where the magic happens!
# it does nothing here but it will do everything
# when it's overridden in subclasses
func scramble_bits(bit_array):
	return bit_array



## Bit traversal and lookups

func get_bit(index):
	return current_bits[index]

func get_target_bit(index):
	return target_bits[index]

func get_right(index):
	var x = int(index + 1)
	if x % cols == 0:
		return -1
	return x

func get_left(index):
	var x = int(index - 1)
	if x < 0 or x % cols == 1:
		return -1
	return x

func get_below(index):
	var x = int(index + cols)
	if x > total:
		return -1
	return x

func get_above(index):
	var x = index - cols
	if x < 0:
		return -1
	return x

func get_corner(index, horiz='left', vert='above'):
	var h_valid
	var v_valid
	var _corner

	v_valid = call('get_' + vert, index)
	h_valid = call('get_' + horiz, index)
	if h_valid == -1 or v_valid == -1:
		return -1

	else:
		_corner = call('get_' + horiz, v_valid)
		return _corner






#################### OLD STUFF COPIED OVER STARTS here
####
##

	
# Takes an array of bit indexes, returns the corresponding bit nodes
func select_group(indexes):
	var group = []
	for index in indexes:
		group.append(puzzle_grid.get_child(index))
	return group


## Presentation methods
# These handle actually displaying which bits are selected at any given time
# Note how this is composed - the first functions define what "highlighting"
# a node means, then the others just reference whatever that definition is.
# That means if later we want to change how highlighting is done,
# we only have to update the basic highlight() and unhighlight() functions.

# Right now, we "highlight" by forcing a bit node to draw
# itself with its "hovered" state instead of its default.
# We reset this when we stop highlighting it.

func highlight(node):
	active_group.append(node)
	if node != null and node.get_stylebox('focus'):
		node.add_style_override('normal', node.get_stylebox('focus'))

func unhighlight(node):
	active_group.erase(node)
	if node != null and node.get_stylebox('focus'):
		node.add_style_override('normal', node.get_stylebox('pressed'))

# Shortcut to reset all highlighting
func clear_highlight():
	for child in puzzle_grid.get_children():
		unhighlight(child)

func highlight_group(group):
	clear_highlight()
	
	for node in group:
		call_deferred('highlight', node)


# Hook up the dropdown menu for switching modes
# (this is really just for demo purposes, at least for now)

func setup_modes():
	var switcher = find_node("mode_switch")
	var popup = switcher.get_popup()
	popup.connect('item_pressed', self, 'set_mode')
	

# Whenever we change modes, we overwrite the way a node responds
# to being hovered on to match the new selection cursor.
func set_mode(which):
	selection_mode = which
	print(which)
	for bit in puzzle_grid.get_children():
		bit.disconnect('mouse_enter', self, 'highlight_by')
		bit.connect('mouse_enter', self, 'highlight_by', [bit, which])

# Making helpers specifically to highlight a row/group -
# handy, and keeps the code cleaner and easier to parse.

func highlight_row(node):
	var _row = get_row(node.get_index())
	var _row_nodes = select_group(_row)
	highlight_group(_row_nodes)

func highlight_col(node):
	var _col = get_col(node.get_index())
	var _col_nodes = select_group(_col)
	highlight_group(_col_nodes)

func highlight_box(node, box_width, box_height):
	var index = node.get_index()
	var _box_nodes = select_group(get_box(index, box_width, box_height))
	highlight_group(_box_nodes)

func highlight_cross(node, x_width=3, x_height=3):
	var index = node.get_index()
	var _cross_nodes = select_group(get_cross(index))
	highlight_group(_cross_nodes)

func highlight_by(node, selection_mode):
	
	# Disable all hover effects if the mode is "none", otherwise reset them to normal.
	if selection_mode == 0:
		for bit in puzzle_grid.get_children():
			bit.add_style_override('hover', bit.get_stylebox('pressed'))
	else:
		for bit in puzzle_grid.get_children():
			bit.add_style_override('hover', bit.get_stylebox('focus'))
			
	
	if selection_mode == 1: # single mode
		clear_highlight()
		highlight(node)
	elif selection_mode == 2: # row mode
		highlight_row(node)
	elif selection_mode == 3: # column mode
		highlight_col(node)
	elif selection_mode == 4: # box mode
		highlight_box(node, 2, 2)
	elif selection_mode == 5: # alt box mode
		highlight_box(node, 3, 2)
	elif selection_mode == 6:
		highlight_cross(node, 3, 3)
	else:
		clear_highlight()
		return


## Setup 

func _ready():
	init_bits()
	init_target()
	init_puzzle()
	setup_modes()



# What do we do once it's solved?
func end_game():
	var popup = find_node("PopupPanel")
	popup.popup()
	pass
