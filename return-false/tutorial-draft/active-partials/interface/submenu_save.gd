##### save game in-game submenu
# active-partials/interface/submenu_save.gd
# main.xml, attached to submenu_save
# closely related to submenu_load.gd
# note: most of this should be available somewhere central,
# like utils.gd or another autoloaded script

extends Node

# where do we put savefiles?
const SAVEFILE_DIR = "res://savegames"
const RED = Color("#ec1300")

var utils            # global utils autoload
var _                # somewhat experimental global registry
var entries          # node for displaying existing files
var btn              # save button
var panel            # menu panel container
var input            # filename lineEdit node
var file_cache = []  # array of existing savefile names
var data             # gets set in buttons.gd (parent's functions)



func _ready():
	
	# global autoload
	utils = get_node("/root/utils")
	_ = get_node("/root/_")
	
	# relevant nodes in this submenu
	panel = self.get_node("Control/PopupPanel")
	entries = panel.get_node("hb/files")
	input = panel.get_node("hb/vb/hb").get_child(0)
	btn = panel.get_node("hb/vb/hb").get_child(1)
	
	btn.connect("pressed", self, "_on_btn_pressed")
	entries.connect("button_selected", self, "fill_from_btn")
	
	# initialize the existing files list
	show_file_list()



###### open and close actions
# TODO: see if we can cut out some of these steps/nodes
func open():
	raise()
	get_node("Control").show()
	panel.popup()



func close():
	get_node("Control").hide()
	panel.hide()
	get_parent().get_node("menu_window").raise()



# fill_from_btn
# if one of our "existing file" buttons is clicked,
# autofill the filename input accordingly
func fill_from_btn(i):
	var i_text = entries.get_button_text(i)
	input.set_text(i_text)



# show_file_list
# builds a button array from files found in the save dir
# 1 file = 1 button
# TODO: needs to be called more often to ensure new files show up
func show_file_list():
	
	var entry
	var dir = Directory.new()
	
	# first, empty out the button array
	entries.set("button/count", 0)
	file_cache = []
	
	# confession: I am not sure exactly how list_dir works
	# but it works, so whatever. start reading our savefiles dir
	dir.change_dir(SAVEFILE_DIR)
	dir.list_dir_begin()
	
	# this is, interestingly, how to loop over dir contents:
	entry  = dir.get_next()
	while entry != "":
		# filter out non-files and system files
		if( entry != "." and entry != ".." and entry != ".DS_Store"):
			# strip out everything but the essential filename
			entry = entry.replace(("." + entry.extension()), "")
			# then cache it and create an autofilling button for it
			file_cache.append(entry)
			entries.add_button(entry)
			
		
		# loop, there it is
		entry = dir.get_next()
		
	dir.list_dir_end()



#### _on_savebtn_pressed()
# step 1 of the save process
# unsurprisingly, triggered when the 'save' button is first clicked
func _on_btn_pressed():
	
	var dest
	var overwrite = false
	var field = input.get_text()
	# if our filename field is filled out, we can proceed
	if( field != null and field != "" ):
		
		dest = utils.fn(field)
		# make sure we have all the latest files in our cache
		show_file_list()
		
		# check whether that filename already exists, proceed accordingly
		if( file_cache.find(field) > -1 ):
			try_to_overwrite(field)
		else:
			_on_save_confirmed(field)



#### try_to_overwrite(filename)
# step 2
# gets called if there is already a file by the name we tried to use
func try_to_overwrite(filename):
	
	# change the "save" button to a "confirm" button
	btn.set("text", "overwrite?")
	btn.set("custom_colors/font_color_hover", RED)
	
	# and change its behavior so the next click does the save action
	btn.disconnect("pressed", self, "_on_btn_pressed")
	btn.connect("pressed", self, "_on_save_confirmed", [filename])



#### _on_save_confirmed(dest)
# step 2 OR step 3, depending on whether [dest] is a new file or an overwrite
# this is the function that actually writes to a savefile
func _on_save_confirmed(dest):
	
	# at this point, we should have a data object set on this node
	# (currently buttons.gd does this)
	# which we now access and save to our chosen file path
	utils.save_game(data, utils.fn(dest))
	
	#print("Saved to ", dest)   # for debugging
	
	# if we were overwriting, we altered the save button
	# so now we reset it to its default look and bindings
	btn.set("text", "save")
	btn.set("custom_colors/font_color_hover", null)
	
	if btn.is_connected("pressed", self, "_on_save_confirmed"):
		btn.disconnect("pressed", self, "_on_save_confirmed")
		btn.connect("pressed", self, "_on_btn_pressed")
	
	# update the button array to reflect newly-added files
	show_file_list()
	
	# TODO: test, make sure this is hiding the node it should be
	close()
	get_parent().get_parent().toggle_menu()