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

    map = (arr, fn) ->
      arr.map (item) ->
        fn.call(item, item)

    self =
      applyMapping: ->
        $.getJSON(@sourceUrl()).then(@data)
      reduction: ->
        t = compile @reduceTransform()

        sum map(@data, t)
      data: O []
      headers: ->
        @mapTransform().split(",")
      body: ->
        map(@data, @transform())

      sourceUrl: O "https://api.github.com/gists"
      mapTransform: O "@id, @url, @owner.id"
      reduceTransform: O "@owner.id"
      transform: ->
        compile @mapTransform()

    document.body.appendChild table self
