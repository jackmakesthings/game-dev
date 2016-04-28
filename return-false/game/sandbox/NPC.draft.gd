export(NodePath) var trigger_area
export(NodePath) var approach_point


export(String) var single_option_fallback
export(String) var multi_option_fallback
export(String) var no_options_fallback

export(bool) var show_fallback

# TODO: better handling of global-ish vars like player node
# maybe set up a dependencies pattern?
onready var Player = get_parent().find_node("player")
onready var MUI = get_tree().get_current_scene().find_node("MessageUI")


var player_nearby = false
var dialog_branches = []


## Input & player redirection ##
# When an NPC is clicked on, the player walks over;
# if there's dialogue, it starts once they arrive.
func _on_click():
	var trigger = get_node(trigger_area)
	var x = get_node(approach_point)
	var destination

	if Utils.is_player_nearby(trigger):
		get_tree().set_input_as_handled()
		start_interaction()
	else:
		Player.halt()
		destination = get_canvas_transform().xform(x.get_global_pos())
		Utils.fake_click(destination, 1)


# init/decline conversation
func start_interaction():

	#check_branches()
	if dialog_branches.empty():
		print("no dialogs!")
		end_interaction()
	else:
		# dialog branch checking loop went here
		# remove branches with no active state dialog
		present_conversations(dialog_branches)


func create_branch_option(branch):
	var response = {
		text = branch.dialog_label,
		actions = [
			{
				fn = "enter_branch",
				target = self,
				args = [branch]
			}
		]
	}
	return response



func present_conversations(dialog_branches):

	if !MUI:
		return

	var options = Array()

	if dialog_branches == null or dialog_branches.size() < 1:
		print("npc has nothing to say, somehow")
		end_interaction()

	elif dialog_branches.size() == 1:
		# show whatever the dialog for that branch now is
		pass

	elif dialog_branches.size() > 1:

		for branch in dialog_branches:
			var option = create_branch_option(branch)
			options.append(option)

		# clear MUI dialogue
		MUI.clear()
		MUI.say(multi_option_fallback)
		MUI.responses(options)

		MUI.open()


func end_interaction():
	if !MUI:
		return

	if no_options_fallback and show_fallback:
		MUI.clear()
		MUI.say(no_options_fallback)
		MUI._Responses.add_close()
		MUI.open()

	else:
		MUI.clear()
		MUI.close()

	return

