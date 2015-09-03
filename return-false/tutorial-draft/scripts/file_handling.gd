extends Node
 
# Description:
# Load / save / check for file (savegames)
 
# Usage:
# savef(a,b,c,d) / loadf(b,c,d) / checkf(b)
# a = data (like array or dictionary)
# b = filename (res://savegame.txt)
# c = no password (0) use OS.crypt (1) or password (2)
# d = password
 
# Author (s)
# Marco Heizmann
 
# Version:
# V1.0
 
# Link:
# http://www.godotengine.de/en/script_modules/mod_file
 
######## Test mode should always be present.
func modtest():
	print("Module -mod_file- loaded")
	return true
########
 
# save file
func savef(a, b="res://savegame.txt", c=null, d=null):
	# any data?
	if not a == null:
		# filename correct?
		if b.begins_with('res://') or b.begins_with('user://'):
			var filex = File.new()
			var error
			# write file
			if c == 1:    # with OS.crypt
				error = filex.open_encrypted_with_pass(b, File.WRITE, OS.get_unique_ID())
			elif c == 2:  # with password
				error = filex.open_encrypted_with_pass(b, File.WRITE, d)
			else:
				error = filex.open(b, File.WRITE)
			#now write
			if (filex.is_open()):
				filex.store_var(a)
				filex.close()
				return true
			else:
				return error
		else:
			return false
	else:
		return false
 
# load file
func loadf(b="res://savegame.txt", c=null, d=null):
	# filename correct?
	if b.begins_with('res://') or b.begins_with('user://'):
		# file exists?
		if checkf(b):
			var filex = File.new()
			var error
			var returndata
			# open file
			if c == 1:    # with OS.crypt
				error = filex.open_encrypted_with_pass(b, File.READ, OS.get_unique_ID())
			elif c == 2:  # with password
				error = filex.open_encrypted_with_pass(b, File.READ, d)
			else:
				error = filex.open(b, File.READ)
			#now read
			if (filex.is_open()):
				returndata = filex.get_var()
				filex.close()
				# return filecontent
				return returndata
			else:
				return error
		else:
			return false
	else:
		return false
 
# check for file exists
func checkf(b="res://savegame.txt"):
	# filename correct?
	if b.begins_with('res://') or b.begins_with('user://'):
		# file exists?
		if File.new().file_exists(b):
			return true # file exists
		else:
			return false # file doesn't exist
	else:
		return false # wrong filename