Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Dataset = require "./dataset"
    dataset = Dataset()

    actions = require "./actions"

    sidebar = require "./templates/sidebar"
    document.body.appendChild sidebar
      steps: dataset.steps
      actions: actions
      activeStep: dataset.activeStep
      data: dataset.data

    editor = require "./templates/editor"
    document.body.appendChild editor(dataset)

    inputSpreadsheet = new Handsontable document.querySelector(".input-spreadsheet-data")
    outputSpreadsheet = new Handsontable document.querySelector(".output-spreadsheet-data")

    inputData = O ->
      dataset.inputData()
    inputData.observe inputSpreadsheet.loadData

    outputData = O ->
      dataset.outputData()
    outputData.observe outputSpreadsheet.loadData

    window.publish = ->
      console.log JSON.stringify(dataset.toJSON(), null, 2)
