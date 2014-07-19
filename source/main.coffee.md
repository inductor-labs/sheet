Sheet
=====

Spreadsheets of the future. From the past.

    table = require "./templates/table"
    CoffeeScript = require "coffee-script"

    IDENTITY_FN = (x) -> x
    ADDITIVE_IDENTITY = 0

    O = require "o_0"

    errors = require "./errors"

    add = (a, b) ->
      a + b

    sum = (arr) ->
      arr.reduce(add, ADDITIVE_IDENTITY)

    compileSingle = (source) ->
      try
        errors.clear()
        compiled = CoffeeScript.compile """
          return ->
            #{source}
        """, {bare: true}

        Function(compiled)()
      catch e
        errors.message "Reduction Compilation Error: #{e.message}"

        IDENTITY_FN

    compile = (source) ->
      try
        errors.clear()

        compiled = CoffeeScript.compile """
          return ->
            [#{source}]
        """, {bare: true}

        Function(compiled)()
      catch e
        errors.message "Mapping Compilation Error: #{e.message}"

        IDENTITY_FN

    self =
      applyMapping: ->
        $.getJSON(@sourceUrl()).then(@data)
      reduction: ->
        t = compileSingle @reduceTransform()

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
