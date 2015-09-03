{
  "branches": [
    {
      "actor": "ada",
      "states": {
        "20": {
          "dialogue": "Hi I'm Ada and this is state 20 of the test.",
          "responses": [
            {
              "conditional": "true",
              "conditions": [
                {
                  "owner": "self",
                  "param": "condition_param",
                  "compare": "gt",
                  "val": 3
                }
              ],
              "text": "Let's skip right to 60.",
              "new_state": "60",
              "dialog_action": 1
            },
            {
              "text": "Okay, go to state 40.",
              "new_state": "40",
              "dialog_action": 1
            },
            {
              "text": "<Leave.>",
              "dialog_action": 0
            }
          ]
        },
        "40": {
          "dialogue": "Now we're at state 40!",
          "responses": [
            {
              "conditional": true,
              "conditions": [
                {
                  "owner": "self",
                  "param": "condition_param",
                  "compare": "equals",
                  "val": 4
                }
              ],
              "text": "Make it 60.",
              "new_state": "60",
              "dialog_action": 1
            },
            {
              "text": "<Leave.>",
              "dialog_action": 0
            }
          ]
        },
        "60": {
          "dialogue": "Whoa, 60.",
          "responses": [
            {
              "text": "<Leave.>",
              "dialog_action": 0
            }
          ]
        }
      }
    }
  ]
}