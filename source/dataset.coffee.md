Dataset
=======

Data from a variety of sources.

    Model = require "./model"
    Step = require "./step"

    {defaults} = require "./util"

    O = require "o_0"

    isObject = (value) ->
      value?.toString() is "[object Object]"

    pipelineAtStep = (steps, index) ->
      (output) ->
        steps.slice(0, index).map (step) ->
          step.transducer().pipe()
        .reverse()
        .reduce (pipe, transform) ->
          transform pipe
        , output

    pipelineData = (pipeline, input) ->
      output = []

      append = (row) ->
        output.push row

      pipeline(append)(input)

      output

    transformCell = (cell="") ->
      if isObject(cell)
        JSON.stringify(cell)
      else
        cell

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        data: []
        steps: []

      self.attrObservable "activeStep", "data"

      self.attrModels "steps", Step

      self.steps.observe (newSteps) ->
        self.activeStep newSteps[newSteps.length - 1]

      self.extend
        loadData: ->
          self.data(require("./data")())
          #$.getJSON(@sourceUrl()).then(@data)

        activeIndex: ->
          self.steps().indexOf self.activeStep()

        dataAtIndex: (index) ->
          transformAtStep = pipelineAtStep self.steps(), index
          pipelineData transformAtStep, self.data()

        inputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeIndex())

        outputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeIndex() + 1)

        publish: ->
          if name = prompt "What should we call this sheet?"
            localStorage.setItem "sheet:#{name}", JSON.stringify(self.toJSON())
            console.log JSON.stringify(self.toJSON(), null, 2)

        savedSheets: ->
          sheetKeys = Object.keys(localStorage).filter (key) ->
            key.indexOf("sheet:") >= 0

          sheetKeys.map (key) ->
            {
              name: key.replace("sheet:", "")
              value: localStorage.getItem(key)
            }

          sheetKeys.unshift {
            name: "Choose a sheet to load"
            value: -1
          }

          sheetKeys

        # TODO: handsontable supports loading data from an object literal.
        # Switch to that format.
        toSpreadsheet: (data) ->
          spreadsheet = data.map (row) ->
            for _, value of row
              transformCell(value)

          # Add column names
          if (firstRow = data[0]) && isObject(firstRow)
            spreadsheet.unshift Object.keys(firstRow)

          spreadsheet

      self
