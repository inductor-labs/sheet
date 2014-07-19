Sheet
=====

Data you can touch

    table = require "./templates/table"

    O = require "o_0"

    toTable = (output) ->
      (data) ->
        output data.map (item) ->
          Object.keys(item).map (key) ->
            item[key]

    self =
      new: ->
        self.data.push ["New", 0, 0]
      data: O []
      dataSource: O "https://api.github.com/gists"

    self.dataSource.observe (newSource) ->
      $.getJSON(newSource).then toTable(self.data)

    document.body.appendChild table self
