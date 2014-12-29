Actions
=======

Transducers that can be applied to our dataset

    module.exports =
      [{
        class: "glyphicon-random"
        title: "Add mapping transform"
        data:
          description: "@id, @name, @url, @cost"
          icon: "glyphicon-random"
          name: "mapping"
          type: "Apply mapping function"
          transducer:
            type: "mapping"
            title: "Mapping function"
            description: "Perform operations on a single row and return the same sized dataset. `@` refers to the current row you're working with."
            source: "id: @id, description: @description"
      }, {
        class: "glyphicon-filter"
        title: "Add filter transform"
        data:
          description: "filter records by description"
          icon: "glyphicon-filter"
          name: "filter"
          type: "Apply filter function"
          transducer:
            type: "filter"
            title: "Filter function"
            description: "Filter to rows that match the provided criteria. `@` refers to the current row you're working with."
            source: "@description"
      }, {
        class: "glyphicon-fullscreen"
        title: "Add expand transform"
        data:
          description: "expand records by @url"
          icon: "glyphicon-fullscreen"
          name: "expand"
          type: "Apply expansion function"
          transducer:
            type: "expansion"
            title: "Expansion function"
            description: "Expand"
            source: ""
      }]
