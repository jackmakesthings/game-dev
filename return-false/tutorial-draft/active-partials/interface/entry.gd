extends Object

var entry_id
var entry_label
var entry_content
var type
var can_be_saved

const TYPE_JOURNAL = 0
const TYPE_EMAIL = 1
const TYPE_OTHER = 2



func _init(args):
	for i in args:
		self[i] = args[i]

func _ready():
	
	pass