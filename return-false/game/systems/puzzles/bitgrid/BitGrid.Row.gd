# Row subclass for BitGrid
extends "./BitGrid.Base.gd"

func _init():
	selection_mode = 2

func get_random_index():
	randomize()
	return (randi() % total)

		


func get_row(index):
	# Use % to find the first index in this bit's row,
	# then addition to find the last one, and return the range between them.

	var _start = index - (index % cols)
	var _end = _start + cols
	return range(_start, _end)


func scramble_bits(bit_array):
	if typeof(shuffle_count) != TYPE_INT:
		shuffle_count = 1
	
	for i in range(shuffle_count):
		randomize()
		var target_index = get_random_index()
		print('flipping row at index ', target_index)
		
		var bits_to_flip = i_to_n(get_row(target_index))
		flip_group(bits_to_flip)
		
		
	
	
#	seeds = range(total - 1)
#	var shuffles = shuffle_count
#	for i in range(0, shuffles):
#		var _seed = seeds[get_random_index()]
#		var targets = get_row(_seed)
#		for bit in targets:
#			flip(bit)
#		seeds.erase(_seed)
#	return current_bits
#	
			
			




