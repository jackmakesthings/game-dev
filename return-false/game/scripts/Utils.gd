# Utility & shared methods (autoloaded as utils)
extends Node

func is_click(ev):
	return (ev.type == InputEvent.MOUSE_BUTTON and ev.pressed and ev.button_index == 1)
