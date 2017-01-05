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
                  "fn": "set",
                  "args": ["Pronoun", ["she", "her", "her", "hers"]]
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
                  "fn": "set",
                  "args": ["Pronoun", ["he", "him", "his", "his"]]
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
                  "fn": "set",
                  "args": ["Pronoun", ["they", "them", "their", "theirs"]]
                }
              ],
              "dialog_action": 1
            }
          ]
        },
        "10": {
          "dialogue": [
            "Okay! So you prefer {{Pronoun}}. Good to know."
          ],
          "responses": [
            {
              "text": "Yep.",
              "dialog_action": 0
            }
          ]
        }
      }
    }
  }
}
