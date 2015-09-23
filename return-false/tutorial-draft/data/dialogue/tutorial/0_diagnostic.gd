{
  "Q_ID": "0_diagnostic",
  "label": "Diagnostics",
  "init_at": "0",
   "logs": {
     "20": {
       "title": "Diagnostics",
       "body": "Today the diagnostics quest was at 20.",
       "summary": "Today the diagnostics quest was at 20.",
       "first": true
     },
     "40": {
       "title": "Diagnostics: 40",
       "body": "Reached state 40",
       "summary": "Today the diagnostics quest was at 40."
     },
     "60": {
       "title": "Diagnostics: 60",
       "body": "Reached state 60",
       "summary": "Today the diagnostics quest was at 60."
     },
     "80": {
       "title": "Diagnostics: 80",
       "body": "Reached state 80",
       "summary": "Today the diagnostics quest was at 80."
     },
     "100": {
        "title": "Diagnostics complete!",
        "body": "Completed the diagnostic task.",
        "summary": ""
     }
  },
  "branches": [
    {
      "actor": "terminal",
      "states": {
        "20": {
          "dialogue": "This terminal is inoperable",
          "responses": [
            {
              "text": "<Run diagnostics>",
              "new_state": "30",
              "dialog_action": 1
            },
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "30": {
          "dialogue": "Scanning... \nDiagnostics complete.  \nThe power cable is damaged; a replacement must be located.",
          "responses": [
            {
              "text": "<Leave>",
              "new_state": "40",
              "dialog_action": 0
            }
          ]
        },
        "40": {
          "dialogue": "The power cable is damaged; a replacement must be located.",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "60": {
          "dialogue": "The power cable is damaged. Do you have a replacement?",
          "responses": [
            {
              "text": "<Replace power cable>",
              "new_state": "70",
              "dialog_action": 1
            },
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "70": {
          "dialogue": "Repair complete! \n[i]The terminal flickers to life with a satisfying hum.[/i]",
          "responses": [
            {
              "text": "<Close terminal>",
              "new_state": "80",
              "dialog_action": 0
            }
          ]
        },
        "80": {
          "dialogue": "Repair complete!\nInform the supervising technician.",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        }
      }
    },
    {
      "actor": "engineer",
      "states": {
        "0": {
          "dialogue": "I need you to fix that terminal. Start by running a diagnostic on it.",
          "responses": [
          {
            "text": "<NEW TASK: Diagnose and repair terminal.>",
            "new_state": "20",
            "dialog_action": 0
            }
          ]
        },
        "20": {
          "dialogue": "The terminal has built-in diagnostics; run those to find out what's wrong.",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "80": {
          "dialogue": "You've fixed it? Good work.",
          "responses": [
            {
              "text": "<Mark task completed>",
              "new_state": "100",
              "dialog_action": 0
            }
          ]
        }
      }
    },
    {
      "actor": "cabinet",
      "states": {
        "20": {
          "dialogue": "[i]This cabinet is overflowing with poorly-organized spare parts.[/i]",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "40": {
          "dialogue": "[i]This cabinet is overflowing with poorly-organized spare parts.[/i]",
          "responses": [
            {
              "text": "<Look for a power cable.>",
              "new_state": "50",
              "dialog_action": 1
            }
          ]
        },
        "50": {
          "dialogue": "[i]Buried beneath a pile of unsorted wires, you locate a compatible power cable for the terminal.[/i]",
          "responses": [
            {
              "text": "<Take the cable and leave.>",
              "new_state": "60",
              "dialog_action": 0
            }
          ]
        },
        "60": {
          "dialogue": "[i]You already have the cable you need.[/i]",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        },
        "80": {
          "dialogue": "Repair complete! Inform the supervising technician.",
          "responses": [
            {
              "text": "<Leave>",
              "dialog_action": 0
            }
          ]
        }
      }
    }
  ]
}