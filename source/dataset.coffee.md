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

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        data: []
        steps: []

      self.attrModels "steps", Step

      self.attrObservable ["data"]

      self.steps.observe (newSteps) ->
        self.activeStep newSteps[newSteps.length - 1]

      self.extend
        activeStep: O()
        loadData: ->
          @data(require("./data")())
          #$.getJSON(@sourceUrl()).then(@data)

        inputData: ->
          previousStepIndex = @steps().indexOf @activeStep()

          pipelined = pipelineAtStep(@steps(), previousStepIndex)
          self.toSpreadsheet(pipelineData(pipelined, @data()))

        toSpreadsheet: (data) ->
          # transform dataset into
          # ==================
          # [col1, col2, col3]
          # [val1, val2, val3]
          # ==================
          # structure
          spreadsheet = data.map (row) ->
            for _, value of row
              if isObject(value)
                value = JSON.stringify(value)
              else
                value ?= ""

              value

          if (firstRow = data[0]) && isObject(firstRow)
            # Add column names
            spreadsheet.unshift Object.keys(firstRow)

          spreadsheet

        outputData: ->
          activeStepIndex = @steps().indexOf(@activeStep()) + 1

          pipelined = pipelineAtStep(@steps(), activeStepIndex)
          self.toSpreadsheet(pipelineData(pipelined, @data()))

      self
