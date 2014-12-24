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
          formatData pipelined, @data()

        outputData: ->
          activeStepIndex = @steps().indexOf(@activeStep()) + 1

          pipelined = pipelineAtStep(@steps(), activeStepIndex)
          formatData pipelined, @data()

        toggleResults: (e) ->
          e.preventDefault()

          targetSelector = $(e.currentTarget).data("target")
          $(targetSelector).toggleClass "hidden"

      self
