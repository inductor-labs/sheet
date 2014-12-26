Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    Dataset = require "./dataset"
    dataset = Dataset()

    Actions = require "./actions"
    actions = Actions(dataset.steps, dataset.activeStep)

    sidebar = require "./templates/sidebar"
    document.body.appendChild sidebar
      steps: dataset.steps
      actions: actions
      activeStep: dataset.activeStep

    editor = require "./templates/editor"
    document.body.appendChild editor(dataset)

    inputSpreadsheet = new Handsontable document.querySelector(".input-spreadsheet-data")
    outputSpreadsheet = new Handsontable document.querySelector(".output-spreadsheet-data")

    reloadSpreadsheets = ->
      inputSpreadsheet.loadData dataset.inputData()
      outputSpreadsheet.loadData dataset.outputData()

    dataset.data.observe(reloadSpreadsheets)
    dataset.activeStep.observe(reloadSpreadsheets)

    window.publish = ->
      console.log JSON.stringify(dataset.toJSON(), null, 2)
