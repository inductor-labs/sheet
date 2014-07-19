Sheet
=====

Spreadsheets of the future. From the past.

    table = require "./templates/table"

    compile = require "./compile"

    O = require "o_0"

    add = (a, b) ->
      a + b

    ADDITIVE_IDENTITY = 0
    sum = (arr) ->
      arr.reduce(add, ADDITIVE_IDENTITY)

    self =
      applyMapping: ->
        $.getJSON(@sourceUrl()).then(@data)
      reduction: ->
        t = compile @reduceTransform()

        transformedData = @data.map (d) ->
          t.call(d, d)

        sum(transformedData)
      data: O []
      headers: ->
        @mapTransform().split(",")
      body: ->
        t = @transform()

        @data.map (d) ->
          t.call(d, d)

      sourceUrl: O "https://api.github.com/gists"
      mapTransform: O "@id, @url, @owner.id"
      reduceTransform: O "@owner.id"
      transform: ->
        compile @mapTransform()

    document.body.appendChild table self
