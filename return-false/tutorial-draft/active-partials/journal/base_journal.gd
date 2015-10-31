# journal class

extends Node

var entries = []  

var layer_node     # the direct child of this, used as a canvaslayer
var panel_node     # below that, the control root
var entry_box      # descendant node for viewing an entry
var entry_list_box # descendant node for listing all entries
var completed_list_box

var latest_entry   # some form of reference to the most recent addition
var current_entry  # reference to which is/was most recently opened
var index = 0
var journal_visible = false

var player



######## get_entry_by - query entry by any parameter
func get_entry_by(param, val):
	for entry in entries:
		if( str(entry[param]) == str(val) ):
			return entry


####### entry_exists - checks by id
func entry_exists(id):
	for entry in entries:
		if ( str(entry.entry_id) == str(id) ):
			return true
		else:
			continue
	return false


####### update_journal - process a new or updated entry
func update_journal(args, complete=false):

	args["index"] = self.index
	entry_box.clear()
	
	# Create a new "Entry" object based on args
	var e = Entry.new(args)
	
	# if this entry id exists, update it with this data
	if ( entry_exists(e.entry_id) ):
		e["history"] = get_entry_by('entry_id', e.entry_id)["history"]
		update_entry(e)
		
		if( complete ):
			print("marking entry as complete")
			mark_entry_completed(e)
	
	# otherwise, create a new entry
	else:
		e["history"] = ""
		add_entry(e)

####### add_entry - called once per quest, when the first state change happens
func add_entry(e):
	e.index = index
	var new_btn = Button.new()
	new_btn.set_text(e.title)
	new_btn.set_text_align(0)
	new_btn.set_meta("ind", index)
	new_btn.set_meta("id", e.entry_id)
	entry_list_box.add_child(new_btn)
	new_btn.connect("pressed", self, "show_entry", [e.index+1])
	#entry_list_box.add_button(e.title)
	entries.append(e)
	latest_entry = e.entry_id
	index = index + 1

######## update_entry - add a new step to an existing record
func update_entry(e):
	var target = get_entry_by("entry_id", e.entry_id)
	
	# save the current state of this entry to its history
	# this creates a cumulative log, showing all updates in order
	
	# uncomment to use timestamps - not currently implemented
	# target.history += "[i]" + target.title + " -- " + target.timestamp + "[/i]\n"

	target.history += "[i]" + target.title + "[/i]\n"
	target.history += "" + target.summary + "\n"
	
	# once that's stored, overwrite the entry with the new data
	target.title = e.title
	target.body = e.body
	target.summary = e.summary
	
	target.timestamp = e.timestamp

######## mark_entry_completed - for quests to call upon completion
func mark_entry_completed(e):
	var btns = entry_list_box.get_children()
	var this_btn
	for btn in btns:
		if( btn.get_meta("id") == e.entry_id ):
			this_btn = btn 
		else:
			continue
	
	print(this_btn)
	entry_list_box.remove_child(this_btn)
	completed_list_box.add_child(this_btn)
	#pass


######## show_entry - function invoked by journal buttons
func show_entry(ind):
	get_tree().set_input_as_handled()
	if( ind == 0 ):
		entry_box.clear()
		current_entry = 0
		return
	else:
		var entry = get_entry_by('index', ind - 1)
		
		entry_box.clear()
		
		entry_box.newline()
		entry_box.append_bbcode("[b]" + entry.title + "[/b]")
		entry_box.newline()
		entry_box.append_bbcode(entry.body)
		entry_box.newline()
		entry_box.newline()
		entry_box.append_bbcode(entry.history)

		current_entry = entry


######## show_journal
func show_journal():
	self.show()
	layer_node.set_layer(2)
	panel_node.popup()
	
	#var cur_pos = player.get_global_pos()
	#player.update_path(cur_pos, cur_pos)
	player.set_fixed_process(false)
	journal_visible = true
	
func hide_journal():
	self.hide()
	layer_node.set_layer(-1)
	panel_node.hide()
	player.set_fixed_process(true)
	journal_visible = false
	
	
func toggle_journal():
	if( journal_visible ):
		hide_journal()
	else:
		show_journal()
	
####### ready
func _ready():
	
	# store all our relevant node paths
	layer_node = get_child(0)
	panel_node = layer_node.get_child(0)
	entry_box = panel_node.get_node("HBoxContainer/RichTextLabel")
	entry_list_box = panel_node.get_node("HBoxContainer/ButtonGroup/VBoxContainer")
	completed_list_box = panel_node.get_node("HBoxContainer/ButtonGroup/completed")
	player = get_node("/root/scene").get("player")
	
	hide_journal()
#	demo()


#### demo - for testing purposes, uses mock data
func demo():
	var mocks = get_node("/root/mocks")
	var data = mocks.JRNL.new()
	
	var q1 = data.fake_quest_action(1)
	var q2 = data.fake_quest_action(2)
	var q3 = data.fake_quest_action(3)
	
	update_journal(q1)
	update_journal(q2)
	update_journal(q3)
	
	

####### Entry as a subclass of Journal
class Entry:

	extends Node

	var title = "Task title"
	var body  = "Task status/description"
	var summary = "> Task summary"
	var first
	var timestamp = "0:00"  # store when the entry was added - todo: find out how
	var entry_id = "000"     # should be unique
	var index        # keep track of how many entries were before this, basically
	var history = ""

	func _init(args):
		
		# use the init call ( Entry.new(args) ) to overwrite 
		# the defaults above with whatever gets passed in
		for arg in args:
			self[arg] = args[arg]
		
		# let summary be optional - if not filled out,
		# just use the full entry body	
		if not ( args.has("summary") ):
			self["summary"] = args["body"]

		# for debugging	
		print("Initialized entry ", self.title, " at index ", str(self.index))
	
