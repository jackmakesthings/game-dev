extends Node

# var PRONOUNS = {
# 	'SHE': ['she', 'her', 'her', 'hers'],
# 	'HE': ['he', 'him', 'his', 'his'],
# 	'THEY': ['they', 'them', 'their', 'theirs'],
# 	'CUSTOM': ['[they]', '[them]', '[their]', '[theirs]']
# }

var DataPath = 'res://data/data.txt'

export(Array) var Pronoun setget set_pronoun
export(String) var THEY
export(String) var THEM
export(String) var THEIR
export(String) var THEIRS

func set_pronoun(what):
	Pronoun = what
	THEY = Pronoun[0]
	THEM = Pronoun[1]
	THEIR = Pronoun[2]
	THEIRS = Pronoun[3]

func save_data():
	var savedata = {
		Pronoun=Pronoun,
		THEY=THEY,
		THEM=THEM,
		THEIR=THEIR,
		THEIRS=THEIRS
	}

	var filex = File.new()
	var error = filex.open(DataPath, File.WRITE)

	if (filex.is_open()):
		filex.store_string(savedata.to_json())
		filex.close()
		return true
	else:
		return error

func load_data():
	var saved = File.new()
	if !saved.file_exists(DataPath):
		return

	var dict = {}
	saved.open(DataPath, File.READ)
	dict.parse_json(saved.get_as_text())

	for key in dict:
		self[key] = dict[key]


func _enter_tree():
	set_pronoun(['they', 'them', 'their', 'theirs'])
	load_data()


	# func save_current_quests():

	# 	var filex = File.new()
	# 	for quest in get_all():
	# 		var questdata = inst2dict(quest)
	# 		var error = filex.open(QuestDataPath, File.WRITE)
	# 		if (filex.is_open()):
	# 			filex.store_line(questdata.to_json())
	# 			filex.close()
	# 			return true
	# 		else:
	# 			return error


	# func load_saved_quests():

	#     var saved = File.new()
	#     if !saved.file_exists(QuestDataPath):
	#         return #Error!  We don't have a save to load

	#     # We need to revert the game state so we're not cloning objects during loading.  This will vary wildly depending on the needs of a project, so take care with this step.
	#     # For our example, we will accomplish this by deleting savable objects.
	#     var savenodes = get_tree().get_nodes_in_group("quests")
	#     for i in savenodes:
	#         i.queue_free()

	#     # Load the file line by line and process that dictionary to restore the object it represents
	#     var currentline = {} # dict.parse_json() requires a declared dict.
	#     saved.open(QuestDataPath, File.READ)
	#     while (!saved.eof_reached()):
	#         currentline.parse_json(saved.get_line())

	#         # We have to clear out a few things that inst2dict tries to set for us
	#         # The 'Branch' preload gets stored as a string, which we need to fix
	#         currentline.erase('@path')
	#         currentline.erase('@subpath')
	#         currentline.Branch = QuestBranch

	#         add_quest(currentline)
	#     saved.close()
