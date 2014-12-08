Step
====

A step tracked by in the Transform Timeline.

    Model = require "./model"

    O = require "o_0"

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

      self
