extends Node
 
# Description:
# Modify the position and/or size of a sprite with pixel or percentage
 
# Usage:
# setsize( a, b, c)
# getsize( a )
 
# psize( a, x, y)
# spsize( a, x, y)
# sbsize( a, top, right, bottom, left)
 
# spritecenter( a )
 
# a = sprite node
# b = width in pixel
# c = height in pixel
# x = percent width
# y = percent height
 
# Author (s)
# Marco Heizmann
 
# Version:
# V1.1
 
# Link:
# http://www.godotengine.de/de/script_modules/mod_spriteresize
 
######## Test mode should always be present.
func modtest():
	print("Module -mod_spriteresize- loaded")
	return true
########
 
 
# center sprite to the screen
func spritecenter(sprite):
	# get sizes
	var screen_size = screensize()
	var texture_size = getsize(sprite)
	var fin_pos = Vector2(0,0)
 
	# center option checked?
	if sprite.is_centered():
		fin_pos = screen_size * 0.5
	else:
		fin_pos = screen_size * 0.5 - texture_size * 0.5
 
	# set pos
	sprite.set_global_pos( fin_pos )
 
 
# set size (screen border mode)
func sbsize(sprite, top = 0, right = 0, bottom = 0, left = 0):
	# get current size
	var screen_size = screensize()
 
	# calc
	if sprite.is_centered():
		screen_size.x -= (right + left)*2 # width
		screen_size.y -= (top + bottom)*2 # height
	else:
		screen_size.x -= (right + left) # width
		screen_size.y -= (top + bottom) # height
 
	#set pos
	spritecenter(sprite)
	if sprite.is_centered():
		sprite.set_global_pos( Vector2(  sprite.get_global_pos().x + (left - right), sprite.get_global_pos().y + (top - bottom) ) )
	else:
		sprite.set_global_pos( Vector2(  (left), (top)  ) )
 
	# set scale
	return setsize(sprite, screen_size.x, screen_size.y)
 
 
# set size (screen percent mode)
func spsize(sprite, percentwidth=100, percentheight=null):
	# get current size
	var screen_size = screensize()
 
	# get height and width
	var texture_size = getsize(sprite)
 
	# no width percent given?
	if !percentwidth > 0:
		return false
 
	# calc
	var targetwidth = screen_size.x * (percentwidth * 0.01)
 
	#set scale
	if percentheight:
		var targetheight = screen_size.y * (percentheight * 0.01)
		return setsize(sprite, targetwidth, targetheight)
	else:
		return setsize(sprite, targetwidth)
 
 
# set size (percent mode)
func psize(sprite, percentwidth=100, percentheight=null):
	# get current size
	var texture_size = getsize(sprite)
 
	# no percent given?
	if !percentwidth > 0:
		return false
	if !percentheight:
		percentheight = percentwidth
 
	# nothing to do?
	if percentwidth == 100 and percentheight == 100:
		return false
 
	# calc
	var targetwidth = texture_size.x * (percentwidth * 0.01)
	var targetheight = texture_size.y * (percentheight * 0.01)
 
	#set scale
	return setsize(sprite, targetwidth, targetheight)
 
 
# set size (pixel mode)
func setsize(sprite, width = "*", height = "*"):
	# get current size
	var texture_size = getsize(sprite)
 
	# no size given?
	if str( height ) == "" and str( width ) == "":
		return false
 
	# proportional resizing?
	if str( height ) == "*":
		height = texture_size.x / texture_size.y * width
	if str( width ) == "*":
		width = texture_size.y / texture_size.x * height
 
	# calculate scaling
	var finalscale = Vector2( width, height ) / texture_size
	sprite.set_scale( finalscale )
 
	return( finalscale )
 
 
# get size
func getsize(sprite):
	# return size
	return Vector2( sprite.get_texture().get_width() * sprite.get_scale().x, sprite.get_texture().get_height() * sprite.get_scale().y ) 
 
 
# get screen size
func screensize():
 
	var sizeA
	var sizeB
 
	# Root auslesen
	var root = get_tree().get_root()
	var current_scene = root.get_child( root.get_child_count() -1 )
 
	if current_scene.get_viewport_rect().size.x > 0:
		sizeA = current_scene.get_viewport_rect().size
	else:
		return OS.get_video_mode_size()
 
	sizeB = OS.get_video_mode_size()
 
	if sizeA < sizeB:
		return sizeA
	else:
		return sizeB