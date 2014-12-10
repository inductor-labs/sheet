Transducer
==========

A generalized data transformation

    Model = require "./model"

    module.exports = (I={}, self=Model(I)) ->
      self.attrObservable """
        source
        type
        title
        instructions
      """.split(/\s+/)...

      self
