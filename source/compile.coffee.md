Compile
=======

Compile source code into functions to transform data sets

    CoffeeScript = require "coffee-script"

    errors = require "./errors"

If our transformation function doesn't work fall back to the identity function,
passing data through untransformed.

    IDENTITY = (x) -> x

    module.exports = (source) ->

Hack to treat comma separated lists as arrays

      if source.indexOf(",") >= 0
        source = "[#{source}]"

      try
        errors.clear()

        compiled = CoffeeScript.compile """
          return ->
            #{source}
        """, {bare: true}

        Function(compiled)()
      catch e
        errors.message "Transformation Compilation Error: #{e.message}"

        IDENTITY
