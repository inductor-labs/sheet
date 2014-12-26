Sheet
=====

One sheet of data transforms.

    Model = require "./model"
    Step = require "./step"

    {defaults} = require "./util"

    O = require "o_0"

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
        options: ["URL", "file", "manual entry"]
        sourceUrl: "https://api.github.com/gists"
        steps: []

      self.attrModels "steps", Step

      self.attrObservable """
        data
        options
        sourceUrl
      """.split(/\s+/)...

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
              value ?= ""

              value = JSON.stringify(value) if value.toString() is "[object Object]"

              value

          if (firstRow = data[0]) && firstRow.toString() is "[object Object]"
            spreadsheet.unshift Object.keys firstRow

          spreadsheet

        outputData: ->
          activeStepIndex = @steps().indexOf(@activeStep()) + 1

          pipelined = pipelineAtStep(@steps(), activeStepIndex)
          self.toSpreadsheet(pipelineData(pipelined, @data()))

        toggleResults: (e) ->
          e.preventDefault()

          targetSelector = $(e.currentTarget).data("target")
          $(targetSelector).toggleClass "hidden"

      self
