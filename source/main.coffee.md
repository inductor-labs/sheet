Sheet
=====

Spreadsheets of the future. From the past.

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

    map = (f) ->
      (output) ->
        (input) ->
          output f.call(input, input)

    activePipeline = (steps, activeStep) ->
      activeStepIndex = steps.indexOf activeStep

      (output) ->
        steps.slice(0, activeStepIndex+1).map (step) ->
          map step.transducer().fn()
        .reverse()
        .reduce (pipe, transform) ->
          transform pipe
        , output

    window.outputToElement = (element, pipeline, input) ->
      output = (item) ->
        console.log item
        element.textContent += item + "\n"

      pipeline(output)(input)

      return element

    output = document.createElement "pre"
    document.body.appendChild output

    O ->
      outputToElement(output, activePipeline(steps(), activeStep()), require("./data")())

    document.body.appendChild sidebar
      steps: steps
      actions: actions

    document.body.appendChild table(sheet)
