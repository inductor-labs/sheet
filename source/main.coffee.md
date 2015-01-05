Sheet
=====

Spreadsheets of the future. From the past.

    "use strict"

    O = require "o_0"

    Editor = require "./editor"
    global.editor = editor = Editor()

    Sidebar = require "./templates/sidebar"
    document.body.appendChild Sidebar(editor)

    EditorTemplate = require "./templates/editor"
    document.body.appendChild EditorTemplate(editor)

    inputSpreadsheet = new Handsontable document.querySelector(".input-spreadsheet-data")
    outputSpreadsheet = new Handsontable document.querySelector(".output-spreadsheet-data")

    inputData = O ->
      editor.inputData()
    inputData.observe inputSpreadsheet.loadData

    outputData = O ->
      editor.outputData()
    outputData.observe outputSpreadsheet.loadData

    editor.fromLocalStorage()
