Step
====

A step tracked by in the Transform Timeline.

    Model = require "./model"

    {defaults} = require "./util"

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        transducer: null

      self.attrObservable """
        description
        icon
        name
        type
      """.split(/\s+/)...

      self.extend
        class: ->
          classes = self.name()
          classes += " active" if I.activeStep() is self

          classes

        click: ->
          I.activeStep(self)

        transducer: ->
          I.transducer

      self
