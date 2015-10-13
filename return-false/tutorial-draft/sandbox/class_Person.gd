extends Node

var name
var age
var height
var weight
var job
var has_pets
var city
var interests

func parse_height(ht):
	var feet = floor( ht / 12 )
	var inches = ht - (feet*12)
	return "" + feet + "' " + inches

func _setup():
	var rtl = RichTextLabel.new()
	rtl.set_size(Vector2(600,400))
	add_child(rtl)
	
	if( age > 0 ):
		rtl.add_text(str(age))
		rtl.newline()
		
	if( height > 0 and weight > 0 ):

		rtl.add_text(parse_height(height))
		rtl.add_text(' / ')
		rtl.add_text(weight + " lbs")
		rtl.newline()
		
	if( has_pets ):
		rtl.add_text("Pets: YES")
	else:
		rtl.add_text("Pets: NO")
		rtl.newline()

func setup():
	print(self.get_property_list())	