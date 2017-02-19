{
	"blocks": {
		"1": {
			"_name": "Costello",
			"_pic": "res://assets/temp/costello.png",
			"_text": "This block will get skipped!"
		},
		"2": {
			"_name": "Abbott",
			"_pic": "res://assets/temp/abbott.png",
			"_text": "See, I'm talking again!"
		},
		"3": {
			"_name": "Costello",
			"_pic": "res://assets/temp/costello.png",
			"_text": "Well it should get to this block automatically.",
			"next_block": "END"
		},
		"START": {
			"_name": "Abbott",
			"_pic": "res://assets/temp/abbott.png",
			"_text": "The next block is #2",
			"next_block": "2"
		},
		"END": {
			"_name": "Abbott",
			"_pic": "res://assets/temp/abbott.png",
			"_text": "That's all, folks!"
		}
	}
}
