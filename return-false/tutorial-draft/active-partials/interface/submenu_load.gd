##### load game in-game submenu
# active-partials/interface/submenu_load.gd
# main.xml, attached to submenu_load
# note: most of this should be available somewhere central,
# like utils.gd or another autoloaded script

extends "res://active-partials/interface/submenu_save.gd"

func _on_btn_pressed():
	show_file_list()
	print("load!")