# Inventory base tests
extends "./Inventory.gd"

func test_signal(was_item_added, item):
	if was_item_added:
		print("Inventory update: added ", item.name)
	else:
		print("Inventory update: removed ", item.name)
	
	
func test():
	
	var ln = "----------------------"
	
	connect("inventory_updated", self, "test_signal")
	var test_data_1 = {
		id = "test_id",
		name = "Test Item",
		description = "Well that sure is a thing.",
		image = null,
		thumbnail = null
	}
	
	var test_data_2 = {
		id = "test_2",
		name = "Second Object",
		description = "",
		image = null,
		thumbnail = null
	}
	
	
	# test init state
	print(ln)
	print("Contents should be empty at initialization...")
	if(contents.empty()):
		print("OK")
	else:
		print("FAILED")
	
	
	# add from data
	add_new_item(test_data_1)
	print(ln)
	print("Adding item ", test_data_1.name)
	print("get_contents returns ", get_contents())
	print(ln)
	print("get_item_ids returns ", get_item_ids())
	print(ln)
	print("get_item_names returns ", get_item_names())
	print(ln)
	print("has_item(id) returns ", has_item(test_data_1.id))
	print(ln)
	print("get_item(id) returns ", get_item(test_data_1.id))
	print(ln)
	print("get_item_by(name, Test Item) returns ", get_item_by("name", test_data_1.name))
	print(ln)
	print(ln)

	# add a processed item
	var item2 = Item.new(test_data_2)
	add_item(item2)
	print(ln)
	print("Adding precomposed item ", test_data_2.name)
	print(ln)
	print("get_contents returns ", get_contents())
	print(ln)
	print("get_item_ids returns ", get_item_ids())
	print(ln)
	print("get_item_names returns ", get_item_names())
	print(ln)
	print("has_item(id) returns ", has_item(test_data_2.id))
	print(ln)
	print("get_item(id) returns ", get_item(test_data_2.id))
	print(ln)
	print("get_item_by(name, Second Object) returns ", get_item_by("name", test_data_2.name))
	print(ln)
	print(ln)
	
	print("Removing second item")
	remove_item(item2)
	print(ln)
	print("get_contents returns ", get_contents())
	print(ln)
	print("has_item(id) returns ", has_item(test_data_2.id))
	print(ln)
	print("get_item(id) returns ", get_item(test_data_2.id))
	print(ln)
	print(ln)
	
	print("Removing first item")
	find_and_remove_item(test_data_1.id)
	print(ln)
	print("get_contents returns ", get_contents())
	print(ln)
	print("has_item(id) returns ", has_item(test_data_1.id))
	print(ln)
	print("get_item(id) returns ", get_item(test_data_1.id))
	print(ln)
	print("Contents should be empty...")
	if get_contents().empty():
		print("OK")
	else:
		print("FAILED")
	print(ln)
	
