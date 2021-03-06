{
	"blocks": {
		"START": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "Pick a color.",
			"options": [
				{
					"text": "Red",
					"next_block": "PICKED_RED"
				},
				{
					"text": "Blue",
					"next_block": "PICKED_BLUE"
				},
				{
					"text": "Green",
					"next_block": "PICKED_GREEN"
				}
			]
		},
		"PICKED_RED": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": [
				{"text": "Red?", "wraps": ["[color=red]", "[/color] "]},
				{"text": "What are you, a "},
				{"text": "commie?", "wraps": ["[color=red]", "[/color]"]}
			],
			"options": [
				{
					"text": "Only on weekends",
					"next_block": "MEH_END"
				},
				{
					"text": "Workers of the world, unite!",
					"next_block": "GOOD_END"
				}
			]
		},
		"PICKED_BLUE": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "Da ba dee da ba die...",
			"options": [
				{
					"text": "Un tss un tss un tss",
					"next_block": "GOOD_END"
				},
				{
					"text": "Eurobeat sucks.",
					"next_block": "MEH_END"
				}
			]
		},
		"PICKED_GREEN": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "Environmentalist-type, eh?",
			"options": [
				{
					"text": "Save the whales, bro.",
					"next_block": "GOOD_END"
				}
			]
		},
		"GOOD_END": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "[i](Abbott high-fives you.)[/i]",
			"next_block": ""
		},
		"MEH_END": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "[i](Annoyed grunt.)[/i]",
			"next_block": ""
		}
	}
}
