Actions
=======

Transducers that can be applied to our dataset

    O = require "o_0"
    Step = require "./step"

    module.exports = (steps) ->
      return O [{
        class: "glyphicon-th"
        title: "Add dataset transform"
        click: ->
          steps.push Step
            description: "Dataset - url"
            icon: "glyphicon-th"
            name: "dataset"
            type: "Dataset"
      }, {
        class: "glyphicon-pencil"
        title: "Add edit transform"
        click: ->
          steps.push Step
            description: "add 2 rows, remove 1 column, edit 6 cells"
            icon: "glyphicon-pencil"
            name: "edit"
            type: "Add, remove, or edit records"
      }, {
        class: "glyphicon-random"
        title: "Add mapping transform"
        click: ->
          steps.push Step
            description: "@id, @name, @url, @cost"
            icon: "glyphicon-random"
            name: "mapping"
            type: "Apply mapping function"
      }, {
        class: "glyphicon-filter"
        title: "Add aggregate transform"
        click: ->
          steps.push Step
            description: "sum records by @cost"
            icon: "glyphicon-filter"
            name: "aggregate"
            type: "Apply aggregate function"
      }, {
        class: "glyphicon-fullscreen"
        title: "Add expand transform"
        click: ->
          steps.push Step
            description: "expand records by @url"
            icon: "glyphicon-fullscreen"
            name: "expand"
            type: "Apply expansion function"
      }]
