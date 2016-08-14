# BitGrid

# 99% of the time, the first thing in your script will be an "extends" 
# This tells the engine "treat this node as a ___, with my extra stuff on top"
# When in doubt, Node is the most basic type you can include in a scene.
extends Node

# Right after the 'extends' statement, you can setup your script's variables.
# These become properties of the node that you can retrieve as needed.

# Putting 'export' before a var means you can change it in the editor
# and that value will be saved when the scene is. For export vars,
# you have to provide a type hint and/or default value:
#
# export(int) var cols      ||   export var cols = 1
# export(String) var name   ||   export var name = "Ted"

export(int) var cols
export(int) var rows


# Exporting a var as (int, "value", "other value", etc) makes it an enum - 
# the value in the editor will be a dropdown with the readable names,
# but will be saved as an integer (None = 0, Single = 1, Row = 2, etc)
export(int, "None", "Single", "Row", "Column", "2x2", "3x2", "X") var selection_mode


# We'll store the currently selected bit group in an array
var active_group = []

# These will represent our grid contents, once initialized
var _bits = []
var target_bits
var current_bits

# When you want a variable to represent a node, use onready - 
# otherwise this script may try to set the var before that node exists in the tree.

onready var target_grid = find_node("target")
onready var puzzle_grid = find_node("puzzle")
onready var total = cols * rows


## Methods

# Utilities

# Helper when we want to switch a bit between 1 and 0
# We force-convert it to a string with str(), so it will work
# whether we pass in "1" (a string) or 1 (an integer).
func get_opposite(bit):
	if str(bit) == "0":
		return '1'
	return '0'

# This returns a new copy of an array with the contents randomly reordered.
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

# Helper for instancing buttons and setting their styles
# (In the real game, the size flags will be handled via our UI theming.)
func make_btn(text):
	var _btn = Button.new()
	_btn.set_h_size_flags(3)
	_btn.set_v_size_flags(3)
	_btn.set_text(text)
	return _btn

# Simple check for 'do the grids match', called after every move
func is_solved():
	return (current_bits == target_bits)

# The actual switching method
func flip(bit):
	var _old = bit.get_text()
	var _new = get_opposite(_old)
	var _index = bit.get_index()
	current_bits[_index] = _new
	bit.set_text(_new)

# A wrapper around flip() that calls it on all the actively highlighted bits
func flip_group():
	for bit in active_group:
		flip(bit)

	# After every move, see if our grids match yet
	if is_solved():
		end_game()


## Minigame setup
# The next few methods all get called in sequence whenever we load the puzzle;
# we could combine them into one function, but I like to keep things modular.
# Plus, I can think of situations where we might only want to call one
# or two of these, not the whole process.

# Step 1: generate an array of 1s and 0s.
# Note: we always start with a 50/50 array of 1s and 0s just for convenience;
# we could tweak this later if we want to allow different mixes.
func init_bits():
	for i in range(0, cols*rows/2):
		_bits.append(0)
		_bits.append(1)

# Step 2: Shuffle the array from step 1 and set the new shuffled copy
# as this puzzle's target state (ie, our win condition). Then we generate
# a button for each bit in the array, and add them to the unclickable grid
# to show the player what they need to make.
# (We also set these as disabled so they won't react to clicks or hovers.)
func init_target():
	target_grid.set_columns(cols)
	target_bits = shuffle(_bits)
	for bit in target_bits:
		var _btn = make_btn(bit)
		target_grid.add_child(_btn)
		_btn.set_disabled(true)

# Step 3: Like step 2, but this time we're creating the clickable player grid.
# We shuffle the target array, set that as our 'current bits' value,
# then set up the second grid the same way as before using that new array.
# We also set all these buttons to respond to clicks and mouseovers,
# which functions they should respond with, and which parameters to pass in.
func init_puzzle():
	puzzle_grid.set_columns(cols)
	current_bits = shuffle(target_bits)
	for bit in current_bits:
		var _btn = make_btn(bit)
		puzzle_grid.add_child(_btn)

		_btn.connect('pressed', self, 'flip_group', [], 1)
		_btn.connect('mouse_enter', self, 'highlight_by', [_btn, 1])



## Traversal
# Methods for getting sets of bits


# Helper for grabbing the value of a bit at a given position;
# returns 1 or 0, whatever's on that bit in the player grid.
func get_bit(index):
	return current_bits[index]

# Likewise, here's a shortcut for getting what a given bit *should* be.
func get_target_bit(index):
	return target_bits[index]

# All the "get neighbor" methods have the same structure - 
# they find what the index in the requested direction *should* be,
# then compare it against the dimensions and edges of the grid.
# They either return a new bit index or, if you try to get something beyond
# a grid edge (like using get_above in the top row), -1.

func get_right(index):
	var _r = int(index + 1)
	if _r % cols == 0:
		return -1
	return _r

func get_left(index):
	var _l = int(index - 1)
	if _l < 0 or _l % cols == 1:
		return -1
	return _l

func get_below(index):
	var _b = int(index + cols)
	if _b > total:
		return -1
	return _b

func get_above(index):
	var _a = index - cols
	if _a < 0:
		return -1
	return _a

func get_corner(index, h="left", v="above"):

	var h_valid
	var v_valid
	var _corner

	# To make this one clearer, let's say we start with index 6
	# and want its top left corner neighbor, in a 4x3 grid.
	# Watch the inline comments to see what indexes we pull.
	# (remember arrays/indexes start at 0, not 1)

	#		 _ ? _ _
	#		 _ _ 6 _
	#		 _ _ _ _

	# First, make sure both of those edges are valid
	v_valid = call("get_" + v, index)          # 2  [ _ ? @ _ ]
	h_valid = call("get_" + h, index)          # 5  [ _ @ 6 _ ]
	if h_valid == -1 or v_valid == -1:
		return -1

	# Assuming they are, find the corner index
	# by applying one get_ on top of the other.
	# (this could also work reversed)
	else:
		_corner = call("get_" + h, v_valid)     # 1  [ _ @ _ _ ]
		return _corner


## Grouping
# Methods for aggregating a set of bits to do stuff with
# These all return simple arrays of bit indexes; it's up to other methods
# to map these to nodes in the puzzle grid.


func get_row(index):
	# Use % to find the first index in this bit's row,
	# then addition to find the last one, and return the range between them.

	var _start = index - (index % cols)
	var _end = _start + cols
	return range(_start, _end)


func get_col(index):
	var _offset = index % cols
	var _col = []
	var _tmp

	# _offset is our position in the row, so start with that and then
	# increment once for each row in the grid.
	# (so get_col(6) in a 4*4 grid returns [2, 6, 10, 14])
	for i in range(rows):
		_tmp = (i*cols) + _offset
		_col.append(_tmp)
	return _col


# This is a helper for doing edge detection in the grid - 
# since we anchor selections at their top-left corner, we can just check
# for whether we can, starting at our given index, move (x) to the right
# and (y) down without going past either of those edges.
func verify_index(index, x, y):

	# First, if this box would spill over the right edge, we move
	# the starting index (aka the top left corner of the box) to the left
	# by enough spaces to get it all inside the grid.
	if (index + x) % cols < index % cols:
		index -= (index + x ) % cols

	# Then we do the same thing for the bottom edge, moving our index up
	# if it's too far down to fit the whole box below it.
	if index + y*cols > total:
		var _overflow = (index + y*cols) - total
		var _adjustment = floor(_overflow / cols)
		index -= _adjustment*cols

	# Now we know our box will fit, so return this new starting point.
	return index


# Get a rectangle of any dimensions, with its top left corner
# anchored to a given bit index (generally, the bit the player's hovering on.)
# index: Starting bit
# x: Horizontal size of the box
# y: Vertical size of the box
func get_box(index, x=2, y=2):


	# Confirm or adjust our starting point as needed (see above),
	# then do some simple math to assemble a box (aka an array of bit indexes)
	# starting from there. First we build out to the right...
	index = verify_index(index, x, y)
	var _box = range(index, index + x)

	# ...then we build downwards, one row at a time.
	# We repeat this (y) times, giving our box its height.
	# Note the 'if' checks - before we add a bit index to our set,
	# we make sure it a) isn't already in the set
	#									b) is within range for our grid's size
	for _row in range(y):
		var _start = index + (_row*cols)
		var _end = _start + x 
		for _b in range(_start, _end):
			if _box.find(_b) < 0 and range(total).find(_b) > -1:
				_box.append(_b)

	# Once we've done all that, we have an array full of bit indexes
	# representing all the bits/buttons in our box selection area.
	return _box


func get_cross(index):

	index = verify_index(index, 3, 3)
	var _cross = [index]
	var _cross_center = get_corner(index, "right", "below")
	_cross.append(_cross_center)
	_cross.append(get_corner(_cross_center, "right", "below"))
	_cross.append(get_corner(_cross_center, "right", "above"))
	_cross.append(get_below(get_below(index)))
	# _cross.append(get_corner(_cross_center, "right", "above"))
	# _cross.append(get_corner(_cross_center, "left", "below"))
	return _cross


	
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

	# var _cross_nodes = select_group(get_cross(9))
	# highlight_group(_cross_nodes)


# What do we do once it's solved?
func end_game():
	var popup = find_node("PopupPanel")
	popup.popup()
	pass
