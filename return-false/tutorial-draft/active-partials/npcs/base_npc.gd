extends Node2D


# will be used to refer to this instance
export(String) var label = "NPC" 
# source file for data, dialogue, whatever
export(String, FILE) var data_file = "res://assets/npc-data-example.gd"

const TRIGGERS = {
	"node_clicked": 1,
	"area_entered": 2,
	"raycast_intercepted": 3,  # eventually
	"arbitrary": 4              # the 'other' option
}

var trigger_mode

export(bool) var can_interact = true
var is_interacting = false

var data
var quests
var quest

var active_quest

var quest_data

var current_dialogue
var current_responses

var fallback_data
var fallback_dialogue = ""

const message_ui_class = preload("res://active-partials/message-ui/message-ui.xml")
var message_ui = message_ui_class.instance()
var game
var utils
var other_npcs = []
var disabled_npcs


signal activated_quest(quest_param, node)
signal interaction_started(npc)
signal interaction_stopped(npc)
signal interaction_enabled(npc)
signal interaction_disabled(npc)

######
# Interactions - these will have to hook into message_ui too
######

func start_interaction(exclusive):
	if ( self.can_interact == false ):
		print("Cannot interact with ", self.label)
		if( get_tree().get_nodes_in_group("active_npc").size() > 0 ):
			var active_npc = get_tree().get_nodes_in_group("active_npc")[0]
			print("Interaction currently exclusive to ", active_npc.label)
		return
	self.is_interacting = true
	emit_signal("interaction_started", self.label)
	
	if ( exclusive ):
		other_npcs = get_tree().get_nodes_in_group("npcs")
		for o in other_npcs:
			if( o == self ):
				continue
			o.call("disable_interaction")
			o.add_to_group("temp_disabled_npcs")
	print("starting interaction with ", self.label)
	self.add_to_group("active_npc")

func stop_interaction():
	self.is_interacting = false
	emit_signal("interaction_stopped", self.label)
	print("done interacting with ", self.label)
	disabled_npcs = get_tree().get_nodes_in_group("temp_disabled_npcs")
	for n in disabled_npcs:
		n.call("enable_interaction")
		n.remove_from_group("temp_disabled_npcs")
	self.remove_from_group("active_npc")

# Enable/disable interacting with this npc
# Have not implemented these flags yet, but may need them later

func disable_interaction():
	if( self.can_interact == false ):
		return
	self.can_interact = false
	emit_signal("interaction_disabled", self.label)
	print("interaction disabled on ", self.label)

func enable_interaction():
	if( self.can_interact == true ):
		return
	self.can_interact = true
	emit_signal("interaction_enabled", self.label)
	print("interaction enabled on ", self.label)
	

########
# Data management 
########

func load_data(data_file):
	self.data = utils.get_json(data_file)
	#printt(data)

# look up all data for one of this npc's quests, by key
# returns the quest object (if there is one)
func get_data_by_quest(quest):
	if( quest == null ):
		if( not self.active_quest == null ):
			quest = self.active_quest
	if( data.size() < 1 ):
		load_data(self.data_file)
	if( not data.has("quests") ):
		print("This npc has no quest data!")
		return null
	if( data["quests"].size() < 1 ):
		print("This npc is not configured for any quests.")
		return null
	if( not data["quests"].has(quest) ):
		print("This npc is not involved in quest ", quest)
		return null
	elif( data["quests"][quest].size() > 0 ):
		print("Loaded quest data: ", quest)
		return data["quests"][quest]

# look up just the data for one state of the quest
# returns state data (or null)
func get_data_at_state(state, quest):
	if ( quest == null ):
		return fallback_data
	else:
		quest_data = get_data_by_quest(quest)
		
		if ( not quest_data.has("states") ):
			print("No states found for this quest")
			return null
		
		var states = quest_data["states"]
		if( not states.has(state) ):
			print("No state matching ", state, " in ", quest)
			return null
		
		else:
			print("\nLoaded data for state ", state, " in quest ", quest)
			if( states[state].keys().size() < 2 ):
				print("WARNING: State exists, but contains no data!")
			return states[state]


# parse the state data returned by the above function
# and return the "dialogue" value. 
# shortcut for get_data_at_state()["dialogue"]
func get_dialogue_from_data(obj):
	if ( not obj.has("dialogue") ):
		print("No dialogue available at this state")
		return null
	elif ( obj.has("dialogue") and obj["dialogue"].length() < 1 ):
		print("WARNING: Dialogue field is empty at this state")
		return ""
	else:
		print("Found dialog: ", obj["dialogue"])
		return obj["dialogue"]


# parse the state data returned by the above function
# and return the "options" (responses) array. 
# shortcut for get_data_at_state()["options"]
func get_options_from_data(obj):
	if( not obj.has("options") ):
		print("No response options available at this state")
		return null
	if( obj["options"].size() > 0 ):
		print("Found ", obj["options"].size(), " response options.")
		return obj["options"]
			

func set_active_quest(quest):
	var quest_param = quest
	self.active_quest = quest_param 
	emit_signal("activated_quest", quest_param, self.label)
	print("Active quest for ", self.label, " is now ", quest_param)



# for debugging purposes
func sigtest(arg1, arg2, arg3):
	print("Signal '", arg3, "' emitted with params ", str(arg1), " and ", str(arg2))


func _init():
	pass
	#add_user_signal("activated_quest", ["quest_param", "node"])

func _ready():
	game = get_node("/root/scene")
	utils = get_node("/root/utils")
	load_data(self.data_file)
	
	other_npcs = get_tree().get_nodes_in_group("npcs")
	
	self.add_to_group("npcs")
	#connect("activated_quest", self, "sigtest", [quest, self.label])
	# message_ui = game.message_ui
	pass