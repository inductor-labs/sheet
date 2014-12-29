Step
====

A step tracked by in the Transform Timeline.

    Model = require "./model"
    Transducer = require "./transducer"

    module.exports = (I={}, self=Model(I)) ->
      self.attrModel "transducer", Transducer

      self.attrObservable """
        description
        icon
        name
        type
      """.split(/\s+/)...

      self
