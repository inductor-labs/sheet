Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Step = require "./step"
    activeStep = O()

    Sheet = require "./sheet"
    sheet = Sheet
      activeStep: activeStep

    steps = O []
    steps.observe (newSteps) ->
      activeStep newSteps[newSteps.length - 1]

    Actions = require "./actions"
    actions = Actions(steps, activeStep)

    table = require "./templates/table"
    sidebar = require "./templates/sidebar"

    activePipeline = (steps, activeStep) ->
      activeStepIndex = steps.indexOf activeStep

      (output) ->
        steps.slice(0, activeStepIndex + 1).map (step) ->
          step.transducer().pipe()
        .reverse()
        .reduce (pipe, transform) ->
          transform pipe
        , output

    outputToElement = (element, pipeline, input) ->
      element.textContent = ""
      output = (item) ->
        console.log item
        element.textContent += item + "\n"

      pipeline(output)(input)

      return element

    output = document.createElement "pre"

    O ->
      outputToElement(output, activePipeline(steps(), activeStep()), require("./data")())

    document.body.appendChild sidebar
      steps: steps
      actions: actions

    document.body.appendChild table(sheet)

    document.querySelector(".main").appendChild output
