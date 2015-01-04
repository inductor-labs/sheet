File Reading
============

Read files from a file input triggering an event when a person chooses a file.

Currently we only care about json, and text files, though we may care
about others later.

    detectType = (file) ->
      if /\.json$/.test file.name
        return "json"

      return "text"

    normalizeNewlines = (str) ->
      str.replace(/\r\n/g, "\n").replace(/\r/g, "\n")

    module.exports =
      readerInput: ({chose, encoding, json, text}) ->
        encoding ?= "UTF-8"

        input = document.createElement "input"
        input.type = "file"

        input.onchange = ->
          reader = new FileReader()

          file = input.files[0]

          switch detectType(file)
            when "json"
              reader.onload = (evt) ->
                json? JSON.parse evt.target.result

              reader.readAsText(file, encoding)
            when "text"
              reader.onload = (evt) ->
                text? normalizeNewlines evt.target.result

              reader.readAsText(file, encoding)

          chose?(file)

        return input
