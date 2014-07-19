Sheet
=====

Data you can touch

    table = require "./templates/table"
    CoffeeScript = require "coffee-script"

    O = require "o_0"

    findKeyByValue = (obj, value) ->
      for prop of obj
        if obj.hasOwnProperty(prop)
          if obj[prop] is value
            return prop

    compile = (source) ->
      try
        Function(CoffeeScript.compile(source, {bare: true}))
      catch e
        console.log "Compilation Error: #{e.message}"

    toTable = (transform, headers, body) ->
      if transform.length
        fn = compile(transform)

        (data) ->
          value = fn.call(data[0])
          headers [].concat findKeyByValue(data[0], value)

          body data.map (item) ->
            fn.call(item)

      else
        (data) ->
          headers Object.keys(data[0])

          body data.map (item) ->
            Object.keys(item).map (key) ->
              item[key]

    self =
      click: ->
        $.getJSON(self.dataSource()).then toTable(self.mapTransform(), self.headers, self.body)
      headers: O []
      body: O []
      dataSource: O "https://api.github.com/gists"
      mapTransform: O "return @id"

    document.body.appendChild table self
