{
  "Q_ID": "Q_sandwich",
  "dialog_label": "Sandwiches.",
  "init_at": "0",
  "complete_at": "100",
  "logs": {
    "20": {
      "title": "Make a Sandwich",
      "body": "Today you will make a sandwich. You need bread, peanut butter, jelly, a knife, and a plate.",
      "summary": "Received sandwich instructions."
    },
    "30": {
      "title": "Bread",
      "body": "Find some bread on the counter.",
      "summary": "Obtained bread."
    },
    "40": {
      "title": "PB & J",
      "body": "Find some peanut butter and jelly in the cabinet.",
      "summary": "Obtained peanut butter and jelly"
    },
    "50": {
      "title": "Silverware",
      "body": "Find a knife and plate.",
      "summary": "Obtained knife and plate"
    },
    "60": {
      "title": "Assembly",
      "body": "Assemble the sandwich. Spread peanut butter on one slice of bread and jelly on the other.",
      "summary": "Constructed sandwich"
    },
    "70": {
      "title": "Storage",
      "body": "Put the sandwich in the fridge for later.",
      "summary": "Sandwich refrigerated"
    },
    "80": {
      "title": "Report",
      "body": "Inform the engineer that there is a sandwich in the fridge.",
      "summary": "Informed engineer"
    },
    "100": {
      "title": "COMPLETE",
      "body": "Successfully made a sandwich!",
      "summary": ""
    }
  },
  "popups": {
    "20": "NEW TASK: SANDWICH",
    "100": "TASK COMPLETED"
    },
  "branches": [
    {
      "actor": "engineer",
      "dialog_label": "Sandwiches.",
      "states": {
        "0": {
          "dialogue": "Hey Trace, can you make me a sandwich? I can't stop to eat right now, so just put it in the fridge when you're done.",
          "responses": [
            {
              "text": "<Accept new task: SANDWICH>",
              "new_state": "15",
              "dialog_action": 1
            },
            {
              "text": "<Decline task>",
              "new_state": "5",
              "dialog_action": 1
            }
          ]
        },
        "5": {
          "dialogue": "Aw, man. Well, if you change your mind, let me know...",
          "responses": [
            {
              "text": "<Leave>",
              "new_state": "10",
              "dialog_action": 0
            }
          ]
        },
        "10": {
          "dialogue": "If you're not busy, I could really use that sandwich...",
          "responses": [
            {
              "text": "<Accept new task: SANDWICH>",
              "new_state": "15",
              "dialog_action": 1
            },
            {
              "text": "<Decline task>",
              "new_state": "5",
              "dialog_action": 1
            }
          ]
        },
        "15": {
          "dialogue": "Thanks!",
          "responses": [
            {
              "text": "<Leave>",
              "new_state": "20",
              "dialog_action": 0
            }
          ]
        },
        "20": {
          "dialogue": "Everything you need is in the kitchen.",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "80": {
          "dialogue": "You're done making lunch? I owe you one!",
          "responses": [
            {
              "text": "<Mark task completed>",
              "new_state": "100",
              "dialog_action": 0
            }
          ]
        }
      }
    }
  ]
}