Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    data = require "./data"
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
          @data(data())
          window.dataSource(@data())
          #$.getJSON(@sourceUrl()).then(@data)

          @spreadsheet()

      self
