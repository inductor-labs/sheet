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

    transformCell = (cell) ->
      cell ?= ""

      if isObject(cell)
        JSON.stringify(cell)
      else
        cell

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        data: []
        steps: []

      self.attrObservable ["data"]

      self.attrModels "steps", Step

      self.steps.observe (newSteps) ->
        self.activeStep newSteps[newSteps.length - 1]

      self.extend
        activeStep: O()
        loadData: ->
          @data(require("./data")())
          #$.getJSON(@sourceUrl()).then(@data)

        activeIndex: ->
          @steps().indexOf @activeStep()

        dataAtIndex: (index) ->
          transformAtStep = pipelineAtStep @steps(), index
          pipelineData transformAtStep, @data()

        inputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeIndex())

        outputData: ->
          self.toSpreadsheet self.dataAtIndex(self.activeIndex() + 1)

        toSpreadsheet: (data) ->
          spreadsheet = data.map (row) ->
            for _, value of row
              transformCell(value)

          # Add column names
          if (firstRow = data[0]) && isObject(firstRow)
            spreadsheet.unshift Object.keys(firstRow)

          spreadsheet

      self
