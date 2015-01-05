Dataset
=======

Data from a variety of sources.

    Model = require "./model"
    Step = require "./step"

    FromFile = require "./file_reader"

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
        name: "Untitled"
        sourceText: ""
        sourceUrl: ""
        steps: []

      self.attrObservable "activeStepIndex", "data", "name", "sourceUrl", "sourceText"

      self.attrModels "steps", Step

      self.steps.observe (newSteps) ->
        self.activeStepIndex newSteps.length - 1

      self.extend
        actions: require "./actions"

        loadUrl: ->
          $.getJSON(@sourceUrl()).then(@data)

        loadCSVFromText: (text) ->
          Papa.parse text,
            header: true
          .data

        loadText: ->
          try
            parsed = JSON.parse @sourceText()
          catch
            parsed = self.loadCSVFromText @sourceText()

          @data parsed

        fileInput: ->
          FromFile.readerInput
            json: self.data
            text: (content) ->
              self.data self.loadCSVFromText(content)

        activeStep: ->
          self.steps.get(self.activeStepIndex())

        dataAtIndex: (index) ->
          transformAtStep = pipelineAtStep self.steps(), index
          pipelineData transformAtStep, self.data()

        inputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeStepIndex())

        outputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeStepIndex() + 1)

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
