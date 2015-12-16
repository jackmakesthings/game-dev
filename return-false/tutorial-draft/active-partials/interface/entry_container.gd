# entry_container.gd
# like the journal ui but a bit more generic
# planned for use with "email terminals" etc
extends CanvasLayer

const Entry = preload("entry.gd")

export(String, FILE) var entry_data
var local_entries = []
var saved_entries
var active_entry

var is_open

var entry_list_box
var saved_entry_list_box
var content_box
var dialog
var status_bar


func make_entry(args):
	var entry = Entry.new(args)
	local_entries.append(entry)
	return entry

func add_entry(entry, set=local_entries):
	var entry_button = Button.new()
	entry_button.set_name(entry.entry_label)
	entry_button.set_text(entry.entry_label)
	entry_button.set_meta("id", entry.entry_id)
	entry_button.set_text_align(0)
	if( set == local_entries ):
		entry_list_box.add_child(entry_button)
	else:
		saved_entry_list_box.add_child(entry_button)
	entry_button.connect("pressed", self, "show_entry", [entry.entry_id])


func get_entry_by(value, param="entry_id", set=local_entries):
	for entry in set:
		if( entry[param] != value ):
			continue
		else:
			return entry
	return("error; no entry found")
			
			

func show_entry(entry_id):
	if !is_open:
		open()
	active_entry = get_entry_by(entry_id)
	content_box.set_bbcode(active_entry.entry_content)
	
func show_next_entry():
	var current = entry_list_box.get_pressed_button().get_position_in_parent()
	var next = entry_list_box.get_child(1 + current)
	if( next == null ):
		return
	elif( next extends HSeparator ):
		next = entry_list_box.get_child(2 + current)
	elif( next extends Button ):
		next = next
		
	entry_list_box.set_pressed_button(next)
	show_entry(next.get_meta("id"))
	
func show_prev_entry():
	var current = entry_list_box.get_pressed_button().get_position_in_parent()
	var prev = entry_list_box.get_child(current-1)
	if( prev == null or prev extends HSeparator or prev.get_name() == "entry_header"):
		return
	entry_list_box.set_pressed_button(prev)
	show_entry(prev.get_meta("id"))


func save_entry():
	var entry = get_entry_by(active_entry.entry_id)
	add_entry(active_entry, saved_entries)
	status_bar.set_text("Saved entry '"+ entry.entry_label + "' to local storage")
	
	
func open():
	set_layer(5)
	dialog.popup_centered()
	entry_list_box.set_pressed_button(entry_list_box.get_child(0))
	is_open = true

func close():
	dialog.hide()
	set_layer(-1)
	is_open = false
	queue_free()

func set_internals():
	content_box = find_node("entry_text")
	dialog = find_node("dialog")
	entry_list_box = find_node("entry_list")
	saved_entry_list_box = find_node("saved_entry_list")
	status_bar = find_node("status")
	
	

func _ready():
	set_internals()
	
	var args = { 
		"entry_id": "test", 
		"entry_label": "This is a test", 
		"entry_content": "This is the text content." ,
		"type": 1,
		"can_be_saved": true
	}
	
		
	var args2 = { 
		"entry_id": "test2", 
		"entry_label": "This is another test", 
		"entry_content": "This is the secondary content." ,
		"type": 1,
		"can_be_saved": true
	}
	
	
	add_entry(make_entry(args), local_entries)
	add_entry(make_entry(args2), local_entries)
	
	open()
	#show_entry("test")
	
