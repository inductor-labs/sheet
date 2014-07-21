Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    compile = require "./compile"

    O = require "o_0"

    add = (a, b) ->
      a + b

    ADDITIVE_IDENTITY = 0
    sum = (arr) ->
      arr.reduce(add, ADDITIVE_IDENTITY)

    avg = (arr) ->
      sum(arr) / arr.length

    map = (arr, fn) ->
      arr.map (item) ->
        fn.call(item, item)

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        aggregateTransform: "@[0]"
        aggregator: "Sum"
        data: []
        groupBy: "@owner.id"
        mapTransform: "@id, @url, @owner.id"
        sourceUrl: "https://api.github.com/gists"

      self.attrObservable """
        aggregateTransform
        aggregator
        data
        groupBy
        mapTransform
        sourceUrl
      """.split(/\s+/)...

      self.extend
        loadData: ->
          $.getJSON(@sourceUrl()).then(@data)

        prettyPrintData: ->
          JSON.stringify @data(), null, 2

        headers: ->
          @mapTransform().split ","

        mapping: ->
          compile @mapTransform()

        reduction: ->
          compile @groupBy()

        aggregation: ->
          compile @aggregateTransform()

        body: ->
          map(@data, @mapping())

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
