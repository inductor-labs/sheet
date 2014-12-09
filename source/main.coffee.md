Sheet
=====

Spreadsheets of the future. From the past.

    O = require "o_0"

    Sheet = require "./sheet"
    sheet = Sheet()

    Step = require "./step"

    activeStep = O()
    steps = O []
    steps.observe (newSteps) ->
      activeStep newSteps[newSteps.length - 1]

    Actions = require "./actions"
    actions = Actions(steps, activeStep)

    table = require "./templates/table"
    sidebar = require "./templates/sidebar"

    document.body.appendChild sidebar
      steps: steps
      actions: actions

    document.body.appendChild table(sheet)
