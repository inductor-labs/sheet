Actions
=======

Transducers that can be applied to our dataset

    O = require "o_0"
    Step = require "./step"
    Transducer = require "./transducer"

    module.exports = (steps, activeStep) ->
      return O [{
        class: "glyphicon-th"
        title: "Add dataset transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "Dataset - url"
            icon: "glyphicon-th"
            name: "dataset"
            type: "Dataset"
            transducer: Transducer
              type: "dataset"
              title: "Data source"
      }, {
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
      }, {
        class: "glyphicon-filter"
        title: "Add aggregate transform"
        click: ->
          steps.push Step
            activeStep: activeStep
            description: "sum records by @cost"
            icon: "glyphicon-filter"
            name: "aggregate"
            type: "Apply aggregate function"
            transducer: Transducer
              type: "aggregation"
              title: "Aggregation function"
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
      }]
