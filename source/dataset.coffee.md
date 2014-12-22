Sheet
=====

One sheet of data transforms.

    Model = require "./model"

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

    formatData = (pipeline, input) ->
      text = ""

      output = (item) ->
        console.log item
        text += item + "\n"

      pipeline(output)(input)

      return text

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        data: []
        options: ["URL", "file", "manual entry"]
        sourceUrl: "https://api.github.com/gists"

      self.attrObservable """
        data
        options
        sourceUrl
        activeStep
        steps
      """.split(/\s+/)...

      self.extend
        loadData: ->
          @data(require("./data")())
          #$.getJSON(@sourceUrl()).then(@data)

        inputData: ->
          previousStepIndex = @steps().indexOf @activeStep()

          pipelined = pipelineAtStep(@steps(), previousStepIndex)
          formatData pipelined, @data()

        inputDataCount: ->
          self.inputData().length + " records"

        outputData: ->
          activeStepIndex = @steps().indexOf(@activeStep()) + 1

          pipelined = pipelineAtStep(@steps(), activeStepIndex)
          formatData pipelined, @data()

        outputDataCount: ->
          self.outputData().length + " records"

        toggleResults: (e) ->
          e.preventDefault()
          debugger

          targetSelector = $(e.currentTarget).data("target")
          $(targetSelector).toggleClass "hidden"

      self
