{
  "key": "identity",
  "dialog_label": "Identity",
  "init_at": "0",
  "flags": {
    "identity_set": 0
  },
  "logs": {},
  "popups": {},
  "actors": {
    "engineer": {
      "dialog_label": "Identity setup",
      "states": {
        "0": {
          "dialogue": "Which pronouns do you prefer?",
          "responses": [
            {
              "text": "She/her/hers",
              "new_state": "10",
              "actions": [
                {
                  "target": "Data",
                  "fn": "set_pronoun",
                  "args": [["she", "her", "her", "hers"]]
                }
              ],
              "dialog_action": 1
            },
            {
              "text": "He/him/his",
              "new_state": "10",
              "actions": [
                {
                  "target": "Data",
                  "fn": "set_pronoun",
                  "args": [["he", "him", "his", "his"]]
                }
              ],
              "dialog_action": 1
            },
            {
              "text": "They/them/theirs",
              "new_state": "10",
              "actions": [
                {
                  "target": "Data",
                  "fn": "set_pronoun",
                  "args": [["they", "them", "their", "theirs"]]
                }
              ],
              "dialog_action": 1
            }
          ]
        },
        "10": {
          "dialogue": "Okay! So you prefer {{THEY}}. Good to know.",
          "responses": [
            {
              "text": "Yep.",
              "dialog_action": 0,
              "new_state": "20"
            }
          ]
        },
        "20": {
          "dialogue": "Last time we talked, you said you preferred '{{THEY}}' pronouns. Are you still okay with that?",
          "responses": [
            {
              "text": "Yes, that's fine.",
              "dialog_action": 0,
              "new_state": "20"
            },
            {
              "text": "I'd like to change this preference.",
              "dialog_action": 1,
              "new_state": "0"
            }
          ]
        }
      }
    }
  }
}
