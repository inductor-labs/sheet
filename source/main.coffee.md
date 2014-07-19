Sheet
=====

Data you can touch

    table = require "./templates/table"

    O = require "o_0"

    toTable = (headers, body) ->
      (data) ->
        headers Object.keys(data[0])

        body data.map (item) ->
          Object.keys(item).map (key) ->
            item[key]

    self =
      headers: O []
      body: O []
      dataSource: O "https://api.github.com/gists"

    self.dataSource.observe (newSource) ->
      $.getJSON(newSource).then toTable(self.headers, self.body)

    document.body.appendChild table self
