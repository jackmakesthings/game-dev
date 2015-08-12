# journal class

extends Node

var entries = []   # an array of what, who knows...
var entry_box      # descendant node for viewing an entry
var entry_list_box # descendant node for listing all entries
var close_button   # node ref, may move to broader ui class
var latest_entry   # some form of reference to the most recent addition
var current_entry  # reference to which is/was most recently opened
var index = 0

	
func extend(obj, with):
	for key in obj:
		if( with.has(key) ):
			obj.key = with.key
	return obj


func entry_exists(id):
	for entry in entries:
		if ( entry.entry_id == id ):
			return true
		else:
			continue
	return false

func update_journal(args):
	entry_box.clear()
	var new_entry = Entry.new(args)
	if ( entry_exists(new_entry.entry_id) ):
		new_entry["summaries"] = get_entry_by('entry_id', new_entry.entry_id).get("summaries")
		update_entry(new_entry)
	else:
		new_entry["summaries"] = []
		add_entry(new_entry)

func add_entry(new_entry):
	new_entry.index = index
	entry_list_box.add_button(new_entry.title)
	entries.append(new_entry)
	latest_entry = new_entry.entry_id
	index = index + 1
	#new_entry["summaries"] =
	#new_entry.summaries = []

func update_entry(new_entry):
	var target = get_entry_by("entry_id", new_entry.entry_id)
	target.body = new_entry.body
	target.timestamp = new_entry.timestamp
	target["history"].append(new_entry.summary)
		

func get_entry_by(param, val):
	for entry in entries:
		if( entry[param] == val ):
			return entry

func show_entry(button):
	var entry = get_entry_by('index', button)
	entry_box.clear()
	#if( entry.has_property("summaries") or entry.has("summaries")):
	#	if( entry.get("summaries").size() > 0 ):
	#		for s in entry.summaries:
	#			entry_box.add_text(s)
	#			entry_box.newline()
	entry_box.add_text(entry.body)
	current_entry = entry

func _ready():
	entry_box = get_node("Control/HBoxContainer/Panel/MarginContainer/RichTextLabel")
	entry_list_box = get_node("Control/HBoxContainer/Panel/VButtonArray")
	#entry_list_box.connect("button_selected", self, "show_entry")

	var new_entry_args = {
	title = "Hello World",
	body = "Beep boop",
	timestamp = "Now",
	entry_id = 111
	}
	
	var new_entry_args2 = {
	title = "My first day on the job",
	body = "Meep moop zarp",
	timestamp = "Later",
	entry_id = 222
	}
	
	add_entry(new_entry_args)
	add_entry(new_entry_args2)




class Entry:
	var title = ""
	var body  = ""
	var summary = ""
	var timestamp    # store when the entry was added - todo: find out how
	var entry_id     # should be unique
	var index        # keep track of how many entries were before this, basically
	var history = []
	
	var defaults = {
		title = "Task title",
		body = "Task status/description.",
		summary = "> Task summary.",
		timestamp = "0:00",
		entry_id = 000
	}
	
	
	func _init(args):
		for arg in defaults:
			self[arg] = defaults[arg]
		
		for arg in args:
			self[arg] = args[arg]
			
		self["index"] = index
		print("Initialized entry ", self.title, " at index ", str(self.index))
	