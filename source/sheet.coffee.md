Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    compile = require "./compile"
    data = require "./data"
    {map, sort} = require "./transforms"

    O = require "o_0"

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
        sortTransform: "@owner.id"
        sourceUrl: "https://api.github.com/gists"

      self.attrObservable """
        aggregateTransform
        aggregator
        data
        groupBy
        mapTransform
        sortTransform
        sourceUrl
      """.split(/\s+/)...

      self.extend
        loadData: ->
          @data(data())
          #$.getJSON(@sourceUrl()).then(@data)

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

Helpers
-------

    defaults = (target, objects...) ->
      for object in objects
        for name of object
          unless target.hasOwnProperty(name)
            target[name] = object[name]

      return target
