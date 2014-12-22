Actions
=======

Transducers that can be applied to our dataset

    O = require "o_0"
    Step = require "./step"
    Transducer = require "./transducer"

    module.exports = (steps, activeStep) ->
      return O [{
        class: "glyphicon-pencil"
        title: "Add edit transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "add 2 rows, remove 1 column, edit 6 cells"
            icon: "glyphicon-pencil"
            name: "edit"
            type: "Add, remove, or edit records"
            transducer: Transducer
              type: "edit"
              title: "Add, remove, or edit data rows"
      }, {
        class: "glyphicon-random"
        title: "Add mapping transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "@id, @name, @url, @cost"
            icon: "glyphicon-random"
            name: "mapping"
            type: "Apply mapping function"
            transducer: Transducer
              type: "mapping"
              title: "Mapping function"
              description: "Perform operations on a single row and return the same sized dataset. `@` refers to the current row you're working with."
              source: "id: @id, description: @description"
      }, {
        class: "glyphicon-filter"
        title: "Add filter transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "sum records by @cost"
            icon: "glyphicon-filter"
            name: "filter"
            type: "Apply filter function"
            transducer: Transducer
              type: "filter"
              title: "Filter function"
              description: "Filter to rows that match the provided criteria. `@` refers to the current row you're working with."
              source: "@description?.length"
      }, {
        class: "glyphicon-fullscreen"
        title: "Add expand transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "expand records by @url"
            icon: "glyphicon-fullscreen"
            name: "expand"
            type: "Apply expansion function"
            transducer: Transducer
              type: "expansion"
              title: "Expansion function"
              description: "Expand"
              source: ""
      }]
