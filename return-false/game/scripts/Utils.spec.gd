# Util tests
extends "./Utils.gd"

# test_cfg
# Testing stub for the config functions
func test_cfg():
	save_cfg([
		{
			section = "Character",
			key = "pronouns",
			val = "she/her"
		}
	])

	var data = load_cfg()
	var pronouns = data.get_value("Character", "pronouns")
	print("You chose to use ", pronouns, ".")
