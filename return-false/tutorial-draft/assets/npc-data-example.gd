{
  "name": "terminal",
  "label": "Terminal",
  "quests": [
    {
      "key": "tutorial",
      "minState": "20",
      "maxState": "80",
      "states": {
        "20": {
          "dialogue": "This terminal is inoperable",
          "internal": false,
          "options": [
            {
              "text": "Run diagnostic function",
              "endState": "30",
              "action": "next_dialog"
            },
            {
              "text": "Leave",
              "endState": "20",
              "action": "end_dialog"
            }
          ]
        },
        "30": {
          "dialogue": "Scanning...Diagnostics complete.  The power cable is damaged; a replacement must be located.",
          "internal": true,
          "options": [
            {
              "text": "Leave",
              "endState": "40",
              "action": "end_dialog"
            }
          ]
        },
        "40": {
          "dialogue": "The power cable is damaged; a replacement must be located.",
          "internal": false,
          "options": [
            {
              "text": "Leave",
              "endState": "40",
              "action": "end_dialog"
            }
          ]
        },
        "60": {
          "dialogue": "The power cable is damaged. Do you have a replacement?",
          "internal": false,
          "options": [
            {
              "text": "Replace power cable",
              "endState": "70",
              "action": "next_dialog"
            },
            {
              "text": "Leave",
              "endState": "60",
              "action": "end_dialog"
            }
          ]
        },
        "70": {
          "dialogue": "Success. The terminal flickers to life with a gentle hum.",
          "internal": true,
          "options": [
            {
              "text": "Close terminal",
              "endState": "80",
              "action": "end_dialog"
            }
          ]
        },
        "80": {
          "dialogue": "Nice work. Go tell the engineer!",
          "internal": false,
          "options": [],
          "text": "Leave",
          "endState": "80",
          "action": "end_dialog"
        }
      }
    }
  ]
}