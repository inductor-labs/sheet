Sheet
=====

Data you can touch

    table = require "./templates/table"

    O = require "o_0"

    self =
      new: ->
        self.data.push ["New", 0, 0]
      data: O [
        ["Duder", 1, 2]
        ["Hello", 3, 4]
        ["Radical", 5, 6]
      ]

    document.body.appendChild table self
