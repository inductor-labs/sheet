Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    {defaults} = require "./util"

    O = require "o_0"

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
      """.split(/\s+/)...

      self.extend
        loadData: ->
          @data(require("./data")())
          #$.getJSON(@sourceUrl()).then(@data)

      self
