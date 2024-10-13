name: 🐞 Bug Report
description: ⚠️ Report bugs, glitches, or issues encountered on the JeriCraft server.
title: "[BUG] <title>"
labels: [ "Bug", "Needs Triage" ]
assignees: Chalwk77
body:
- type: markdown
  attributes:
  value: |
  **📌 Describe the bug**
  > Provide a clear and concise descriptions in the following sections.
  > Use headers (`#`) or lists (`-`) to organize your thoughts.
- type: textarea
  id: minecraft-username
  attributes:
  label: 🎮 Minecraft Username
  description: Provide your Minecraft username.
  placeholder: "Your Minecraft Username"
  validations:
  required: true
- type: textarea
  id: date-time
  attributes:
  label: 🕒 Date and Time of the Incident (if known)
  description: Provide the date and time of the incident.
  validations:
  required: false
- type: textarea
  id: describe-bug
  attributes:
  label: 🐛 Describe the bug
  description: Describe the bug encountered on the JeriCraft server.
  placeholder: "Describe the bug here"
  validations:
  required: true
- type: textarea
  id: location
  attributes:
  label: 📍 Location
  description: Describe the location in the JeriCraft server where you experienced the bug.
  placeholder: "Provide location details (coordinates, biome, or nearby structures)"
  validations:
  required: true
- type: textarea
  id: steps-to-reproduce
  attributes:
  label: 🔄 Steps to Reproduce
  description: List the steps required to reproduce the bug.
  placeholder: "1. Step 1, 2. Step 2, etc."
  validations:
  required: true
- type: textarea
  id: expected-behavior
  attributes:
  label: 🎯 Expected Behavior
  description: Describe what should have happened if the bug hadn't occurred.
  placeholder: "Explain the expected behavior"
  validations:
  required: true
- type: textarea
  id: additional-context
  attributes:
  label: 📝 Additional Context
  description: Write any other context or information about the bug here.
  placeholder: "Further context or information here"
  validations:
  required: true
- type: markdown
  attributes:
  value: |
  **📷 Screenshots**
  > Include any relevant screenshots to help illustrate the bug.
  >
  >
  > 🙌 Thank you
  >
  > **We appreciate your effort in reporting bugs on the JeriCraft server. Your input is invaluable!**