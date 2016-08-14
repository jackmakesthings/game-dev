# Col type BitGrid puzzle

extends "./BitGrid.Base.gd"

func _get_col(index):
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

# aliased interface
func _selection_from(index):
	return _get_col(index)
