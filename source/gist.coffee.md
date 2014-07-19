Gist
====

Save or load anonymous gists.

    base = "https://api.github.com/gists"

    module.exports =
      save: (data, description) ->
        data =
          description: description or "Created with #{window.location}"
          public: true
          files:
            "data.json":
              content: JSON.stringify data

        $.ajax base,
          headers:
            Accept: "application/vnd.github.v3+json"
          contentType: "application/json; charset=utf-8"
          data: JSON.stringify data
          dataType: "json"
          type: "POST"
        .then (result) ->
          result.id

      load: (id) ->
        $.get("#{base}/#{id}").then (data) ->
          JSON.parse data.files["data.json"].content
