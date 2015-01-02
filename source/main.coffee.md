Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Dataset = require "./dataset"
    dataset = Dataset()

    Sidebar = require "./templates/sidebar"
    document.body.appendChild Sidebar(dataset)

    EditorTemplate = require "./templates/editor"
    document.body.appendChild EditorTemplate(dataset)

    inputSpreadsheet = new Handsontable document.querySelector(".input-spreadsheet-data")
    outputSpreadsheet = new Handsontable document.querySelector(".output-spreadsheet-data")

    inputData = O ->
      dataset.inputData()
    inputData.observe inputSpreadsheet.loadData

    outputData = O ->
      dataset.outputData()
    outputData.observe outputSpreadsheet.loadData
