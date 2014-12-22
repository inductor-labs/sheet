Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    {defaults} = require "./util"

    O = require "o_0"

    activePipeline = (steps, activeStep) ->
      activeStepIndex = steps.indexOf activeStep

      (output) ->
        steps.slice(0, activeStepIndex + 1).map (step) ->
          step.transducer().pipe()
        .reverse()
        .reduce (pipe, transform) ->
          transform pipe
        , output

    dataOutput = (pipeline, input) ->
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

        rawData: ->
          pipelined = activePipeline @steps(), @activeStep()
          dataOutput pipelined, @data()

      self
