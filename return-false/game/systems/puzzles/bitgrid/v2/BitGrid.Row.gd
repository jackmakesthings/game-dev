# Row type BitGrid puzzle

extends "./BitGrid.Base.gd"

func _get_row(index):
	# Use % to find the first index in this bit's row,
	# then addition to find the last one, and return the range between them.

	var _start = index - (index % cols)
	var _end = _start + cols
	return range(_start, _end)

# aliased interface
func _selection_from(index):
	return _get_row(index)
