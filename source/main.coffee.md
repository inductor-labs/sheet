Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Dataset = require "./dataset"
    dataset = Dataset()

    # TODO: Move into dataset
    dataset.steps.observe (newSteps) ->
      dataset.activeStep newSteps[newSteps.length - 1]

    Actions = require "./actions"
    actions = Actions(dataset.steps, dataset.activeStep)

    editor = require "./templates/editor"
    sidebar = require "./templates/sidebar"

    document.body.appendChild sidebar
      steps: dataset.steps
      actions: actions
      activeStep: dataset.activeStep

    document.body.appendChild editor(dataset)

    window.publish = ->
      console.log dataset.toJSON()
