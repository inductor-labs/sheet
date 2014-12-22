Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Step = require "./step"
    activeStep = O()

    steps = O []
    steps.observe (newSteps) ->
      activeStep newSteps[newSteps.length - 1]

    Dataset = require "./dataset"
    dataset = Dataset
      activeStep: activeStep
      steps: steps

    Actions = require "./actions"
    actions = Actions(steps, activeStep)

    editor = require "./templates/editor"
    sidebar = require "./templates/sidebar"

    document.body.appendChild sidebar
      steps: steps
      actions: actions

    document.body.appendChild editor(dataset)
