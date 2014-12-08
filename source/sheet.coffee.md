Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    compile = require "./compile"
    data = require "./data"
    {map, sort} = require "./transforms"
    {defaults} = require "./util"

    O = require "o_0"

    toSpreadsheet = (data) ->
      if data.length
        headers = Object.keys data[0]

        output = data.map (row) ->
          headers.map (col) ->
            row[col]

        [headers].concat output
      else
        []

    add = (a, b) ->
      a + b

    ADDITIVE_IDENTITY = 0
    sum = (arr) ->
      arr.reduce(add, ADDITIVE_IDENTITY)

    avg = (arr) ->
      sum(arr) / arr.length

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        aggregateTransform: "@[0]"
        aggregator: "Sum"
        data: []
        groupBy: "@owner.id"
        mapTransform: "@id, @url, @owner.id"
        rowSource: "{}"
        sortTransform: "@owner.id"
        sourceUrl: "https://api.github.com/gists"

      self.attrObservable """
        aggregateTransform
        aggregator
        data
        groupBy
        mapTransform
        rowSource
        sortTransform
        sourceUrl
      """.split(/\s+/)...

      self.extend
        addRow: ->
          @data.push JSON.parse(@rowSource())

        loadData: ->
          @data(data())
          #$.getJSON(@sourceUrl()).then(@data)

          @spreadsheet()

        prettyPrintData: ->
          JSON.stringify @data(), null, 2

        headers: ->
          @mapTransform().split ","

        mapping: ->
          compile @mapTransform()

        sorting: ->
          compile @sortTransform()

        reduction: ->
          compile @groupBy()

        aggregation: ->
          compile @aggregateTransform()

        spreadsheet: ->
          $(".spreadsheet").handsontable
            data: toSpreadsheet @data()

        body: ->
          sortResult = sort(@data, @sorting())
          map(sortResult, @mapping())

        aggregatorOptions: ["Sum", "Avg"]

        aggregate: ->
          if @aggregateTransform().length
            mappedData = map(@data, @reduction())
            @aggregation().call mappedData, mappedData
          else
            fn = {
              Sum: sum
              Avg: avg
            }[@aggregator()]

            fn map(@data, @reduction())

      self
