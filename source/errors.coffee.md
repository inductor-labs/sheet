Errors
======

Global error handling

    template = require "./templates/errors"
    O = require "o_0"

    message = O ""

    self =
      class: ->
        "hidden" unless message().length
      message: message
      clear: ->
        message ""

    document.body.appendChild template self

    module.exports = self
