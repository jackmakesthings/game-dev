# journal class

extends Node

var entries = []   # an array of what, who knows...
var entry_box      # descendant node for viewing an entry
var entry_list_box # descendant node for listing all entries
var journal_button   # node ref, may move to broader ui class
var latest_entry   # some form of reference to the most recent addition
var current_entry  # reference to which is/was most recently opened
var index = 0



######## get_entry_by - query entry by any parameter
func get_entry_by(param, val):
	for entry in entries:
		if( entry[param] == val ):
			return entry


####### entry_exixtx - checkx by id
func entry_exists(id):
	for entry in entries:
		if ( entry.entry_id == id ):
			return true
		else:
			continue
	return false


####### update_journal - process a new or updated entry
func update_journal(args):

	args["index"] = self.index
	entry_box.clear()
	var e = Entry.new(args)
	
	# if this entry id exists, update it with this data
	if ( entry_exists(e.entry_id) ):
		e["history"] = get_entry_by('entry_id', e.entry_id)["history"]
		update_entry(e)
	
	# otherwise, create a new entry
	else:
		e["history"] = []
		add_entry(e)


func add_entry(e):
	e.index = index
	entry_list_box.add_button(e.title)
	entries.append(e)
	latest_entry = e.entry_id
	index = index + 1

######## update_entry - add a new step to an existing record
func update_entry(e):
	var target = get_entry_by("entry_id", e.entry_id)
	target["history"].append(target.summary)
	target.body = e.body
	target.timestamp = e.timestamp


######## show_entry - function invoked by journal buttons
func show_entry(ind):
	var entry = get_entry_by('index', ind)
	entry_box.clear()
	entry_box.add_text(entry.body)
	current_entry = entry
	#get_tree().set_input_as_handled()
	#get_node("Control").accept_event()


######## show_journal
func show_journal():
	#get_node("Control").set("z/z", 1)
	get_node("Control/Panel").popup()
	#get_node("Control").accept_event()
	#get_tree().set_input_as_handled()
	
####### ready
func _ready():
	entry_box = get_node("Control/Panel/HBoxContainer/RichTextLabel")
	entry_list_box = get_node("Control/Panel/HBoxContainer/VButtonArray")
	journal_button = get_node("Button")
	get_node("Control/Panel").hide()
	demo()
	


func demo():
	var mocks = get_node("/root/mocks")
	var data = mocks.JRNL.new()
	#update_journal(data.entry1)
	#update_journal(data.entry2)
	
	var q1 = data.fake_quest_action(1)
	var q2 = data.fake_quest_action(2)
	var q3 = data.fake_quest_action(3)
	
	update_journal(q1)
	update_journal(q2)
	update_journal(q3)
	
	journal_button.show()
	journal_button.connect("pressed", self, "show_journal")
	

####### Entry as a subclass of Journal
class Entry:

	extends Node

	var title = "Task title"
	var body  = "Task status/description"
	var summary = "> Task summary"
	var timestamp = "0:00"  # store when the entry was added - todo: find out how
	var entry_id = 000     # should be unique
	var index        # keep track of how many entries were before this, basically
	var history = []

	func _init(args):
		for arg in args:
			self[arg] = args[arg]
		self["history"] = []
		print("Initialized entry ", self.title, " at index ", str(self.index))
	

func _on_Panel_popup_hide():
	#get_node("Control").set("z/z", -1)
	pass # replace with function body


func _on_Panel_about_to_show():
	#get_node("Control").set("z/z", 0)
	pass # replace with function body
