CoffeeScript = require "coffee-script"

errors = require "./errors"

IDENTITY = (x) -> x

module.exports = (source) ->
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
    errors.message "Mapping Compilation Error: #{e.message}"

    IDENTITY
