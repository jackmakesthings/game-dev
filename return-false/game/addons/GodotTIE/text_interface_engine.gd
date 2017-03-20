# MADE BY HENRIQUE ALVES
# LICENSE STUFF BLABLABLA
# (MIT License)
# Tweaked by @jackmakesthings


extends ReferenceFrame
# TODO: is this the best thing to extend from?

const STATE_WAITING = 0
const STATE_OUTPUT = 1

const BUFF_DEBUG = 0
const BUFF_TEXT = 1
const BUFF_SILENCE = 2
const BUFF_BREAK = 3

var _buffer = [] # 0 = Debug; 1 = Text; 2 = Silence; 3 = Break
var _label = RichTextLabel.new() # The Label in which the text is going to be displayed
onready var _initial_size = get_size()
onready var _current_size = get_size()
var _state = 0 # 0 = Waiting; 1 = Output

onready var _output_delay = 0
onready var _output_delay_limit = 0
onready var _on_break = false
onready var _buff_beginning = true
onready var _turbo = false
onready var _break_key = KEY_RETURN

# =============================================== 
# Text display properties!
export(Font) var FONT
# ===============================================


# Get the current contents
func get_bbcode():
	return _label.get_bbcode()

# Changes the state of the Text Interface Engine
func set_state(i): 
	emit_signal("state_change", int(i))
	_state = i


###
# Buffer operations - these push different types of output to the interface
###

# Debug-style output
func buff_debug(f, lab = false, arg0 = null, push_front = false):
	var b = {"buff_type":BUFF_DEBUG,"debug_function":f,"debug_label":lab,"debug_arg":arg0}
	if(! push_front):
		_buffer.append(b)
	else:
		_buffer.push_front(b)


# Standard text printing, at a given speed
# Not sure what 'tag' does yet...
func buff_text(text, vel = 0, wraps=[], tag = "", push_front = false):

	var a = null
	var b = {"buff_type":BUFF_TEXT, "buff_text":text, "buff_vel":vel, "buff_tag":tag}
	var c = null

	if !wraps.empty():
		a = {"buff_type":BUFF_TEXT, "buff_text": wraps[0], "buff_vel":0, "buff_tag":tag}
		c = {"buff_type":BUFF_TEXT, "buff_text": wraps[1], "buff_vel":0, "buff_tag":tag}

	if !push_front:
		if a != null:
			_buffer.append(a)
			_buffer.append(b)
			_buffer.append(c)
		else:
			_buffer.append(b)

	else:
		if a != null:
			_buffer.push_front(c)
			_buffer.push_front(b)
			_buffer.push_front(a)
		else:
			_buffer.push_front(b)


# ...
func buff_silence(len, tag = "", push_front = false):
	var b = {"buff_type":BUFF_SILENCE, "buff_length":len, "buff_tag":tag}
	if !push_front:
		_buffer.append(b)
	else:
		_buffer.push_front(b)


# Stop output until the player hits a key (enter, by default)
# Not currently in our designs but maybe this is useful...
func buff_break(tag = "", push_front = false): 
	var b = {"buff_type":BUFF_BREAK, "buff_tag":tag}
	if !push_front:
		_buffer.append(b)
	else:
		_buffer.push_front(b)


###
# Cleanup functions and resets
###

# Deletes ALL the text on the label
func clear_text(): 
	_label.set_bbcode("")

# Clears all buffs in _buffer, including delays and settings
func clear_buffer(): 
	_on_break = false
	set_state(STATE_WAITING)
	_buffer.clear()
	
	_output_delay = 0
	_output_delay_limit = 0
	_buff_beginning = true
	_turbo = false

# Reset TIE to its initial 100% cleared state
func reset():
	clear_text()
	clear_buffer()


###
# On-the-fly interface changes;
# (Might scrap these functions and let the bbcode do the work, ultimately.)
###

# Changes the font of the text; 
# weird stuff will happen if you use this function after text has been printed
func set_font_bypath(str_path): 
	_label.add_font_override("font",load(str_path))

# Changes font of the text (uses the resource)
func set_font_byresource(font):
	_label.add_font_override("font", font)

# Changes the color of the text
func set_color(c): 
	_label.add_color_override("font_color", c)

# Changes the velocity of the text being printed
func set_buff_speed(v):
	if (_buffer[0]["buff_type"] == BUFF_TEXT):
		_buffer[0]["buff_vel"] = v

# Print stuff in the maximum velocity and ignore breaks
func set_turbomode(s):
	_turbo = s;

# Set a new key to resume breaks (uses scancode!)
func set_break_key_by_scancode(i):
	_break_key = i

# Update the size of the container to avoid clipped lines
# (Called when text is added)
# The 30 is totally arbitrary; provides some padding. Should be >= one line height.
func update_size():
	var new_size = Vector2(_label.get_size().x, _label.get_v_scroll().get_max() + 30)
	if new_size.y != _current_size.y:
		_current_size = new_size
		_label.set_size(new_size)
		set_size(new_size)
		emit_signal("size_change", [_current_size.y])

# ==============================================
# Reserved methods

# Override
func _ready():
	set_fixed_process(true)
	set_process_input(true)
	add_child(_label)
	
	# Setting font of the text
	if(FONT != null):
		_label.add_font_override("font", FONT)

	_label.set_custom_minimum_size(get_size())
	_label.set_scroll_follow(true)
	_label.get_v_scroll().set_opacity(0.0)
	_label.set_use_bbcode(true)

	set('size_flags/vertical', 3)
	set('size_flags/horizontal', 3)
	_label.set('size_flags/vertical', 3)
	_label.set('size_flags/horizontal', 3)
	
	add_user_signal("buff_end") # When there is no more outputs in _buffer
	add_user_signal("state_change",[{"state":TYPE_INT}]) # When the state of the engine changes
	add_user_signal("size_change", [TYPE_INT]) # When the height is updated to fit more text
	add_user_signal("enter_break") # When the engine stops on a break
	add_user_signal("resume_break") # When the engine resumes from a break
	add_user_signal("tag_buff",[{"tag":TYPE_STRING}]) # When the _buffer reaches a buff which is tagged

func _fixed_process(delta):

	# Are we outputting?
	if(_state == STATE_OUTPUT):

		# Well, not if the buffer's empty.
		if(_buffer.size() == 0):
			set_state(STATE_WAITING)
			update_size()
			emit_signal("buff_end")
			return
		
		# But otherwise...
		var o = _buffer[0] # TODO: rename 'o' variable
		
		# Mode 0: Debug. Supports func calls?
		if (o["buff_type"] == BUFF_DEBUG):
			if(o["debug_label"] == false):
				if(o["debug_arg"] == null):
					print(self.call(o["debug_function"]))
				else:
					print(self.call(o["debug_function"],o["debug_arg"]))
			else:
				if(o["debug_arg"] == null):
					print(_label.call(o["debug_function"]))
				else:
					print(_label.call(o["debug_function"],o["debug_arg"]))
			_buffer.pop_front()

		########
		# Mode 1: Basic text printing
		elif (o["buff_type"] == BUFF_TEXT):

			# I guess buff tags are for triggering outside actions?
			if(o["buff_tag"] != "" and _buff_beginning == true):
				emit_signal("tag_buff", o["buff_tag"])
			
			# Gotta go fast?
			if (_turbo):
				o["buff_vel"] = 0
			
			# Printing everything at once
			if(o["buff_vel"] == 0):
				while(o["buff_text"] != ""):
					_label_print(o["buff_text"][0])
					_buff_beginning = false
					o["buff_text"] = o["buff_text"].right(1)
			
			# Printing character by character		
			else:

				# Delay printing till enough time elapses (via delta)
				_output_delay_limit = o["buff_vel"]
				if(_buff_beginning):
					_output_delay = _output_delay_limit + delta
				else:
					_output_delay += delta

				# Once we've waited long enough, print the character
				if(_output_delay > _output_delay_limit):
					_label_print(o["buff_text"][0])
					_buff_beginning = false
					_output_delay -= _output_delay_limit
					o["buff_text"] = o["buff_text"].right(1)
	
			# This buff finished, so pop it out of the array
			if (o["buff_text"] == ""):
				_buffer.pop_front()
				_buff_beginning = true
				_output_delay = 0

		#####
		# Mode 2: silences (pause for effect)
		elif (o["buff_type"] == BUFF_SILENCE):

			if(o["buff_tag"] != "" and _buff_beginning == true):
				emit_signal("tag_buff", o["buff_tag"])
				_buff_beginning = false
			_output_delay_limit = o["buff_length"]
			_output_delay += delta

			# Wait the specified time, then advance the buffer
			if(_output_delay > _output_delay_limit):
				_output_delay = 0
				_buff_beginning = true
				_buffer.pop_front()


		#####
		# Mode 3: Break, for pausing mid-output. Might be useful?
		elif (o["buff_type"] == BUFF_BREAK):

			if(o["buff_tag"] != "" and _buff_beginning == true):
				emit_signal("tag_buff", o["buff_tag"])
				_buff_beginning = false

			# No breaks in turbo mode	
			if(_turbo):
				_buffer.pop_front()

			elif(!_on_break):
				emit_signal("enter_break")
				_on_break = true


# And here's the thing that actually puts text in the box!
func _label_print(t): # Add text to the label
	_label.set_bbcode(_label.get_bbcode() + t)
	update_size()
	return t
