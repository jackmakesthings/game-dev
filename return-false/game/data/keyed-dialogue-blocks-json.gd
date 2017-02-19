{
	"blocks": {
		"1": {
			"name": "Costello",
			"pic": "res://assets/temp/costello.png",
			"text": "This block will get skipped!"
		},
		"2": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "See, I'm talking again!"
		},
		"3": {
			"name": "Costello",
			"pic": "res://assets/temp/costello.png",
			"text": "Well it should get to this block automatically.",
			"next_block": "END"
		},
		"START": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "The next block is #2",
			"next_block": "2"
		},
		"END": {
			"name": "Abbott",
			"pic": "res://assets/temp/abbott.png",
			"text": "That's all, folks!"
		}
	}
}
