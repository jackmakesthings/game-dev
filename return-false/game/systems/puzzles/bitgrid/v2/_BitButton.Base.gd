# Button with encapsulated style switching, for bitgrids
extends Button

var mode = 0

var style_0 = preload("res://systems/puzzles/bitgrid/v2/stylebox_dark_orange.tres")
var style_0_active = preload("res://systems/puzzles/bitgrid/v2/stylebox_orange.tres")
var style_1 = preload("res://systems/puzzles/bitgrid/v2/stylebox_dark_teal.tres")
var style_1_active = preload("res://systems/puzzles/bitgrid/v2/stylebox_teal.tres")

func show_0(hover=true):
	set_text('0')
	set("custom_styles/normal", style_0)
	set("custom_styles/focus", style_0_active)
	set("custom_styles/hover", style_0_active)
	set("custom_styles/pressed", style_0)
	mode = 0
	set_text('')
	set_text('0')

	if hover:
		set("custom_styles/normal", style_0_active)
		set("custom_styles/pressed", style_0_active)

func show_1(hover=true):
	set("custom_styles/normal", style_1)
	set("custom_styles/focus", style_1_active)
	set("custom_styles/hover", style_1_active)
	set("custom_styles/pressed", style_1)
	mode = 1
	set_text('')
	set_text('1')

	if hover:
		set("custom_styles/normal", style_1_active)
		set("custom_styles/pressed", style_1_active)
