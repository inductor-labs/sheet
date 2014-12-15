Transducer
==========

A generalized data transformation

    Model = require "./model"
    O = require "o_0"
    {defaults} = require "./util"

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        source: """
          ->
            @id
        """

      self.attrObservable """
        source
        type
        title
        instructions
      """.split(/\s+/)...

      compile = ->
        wrapped = "return " + self.source()
        code = CoffeeScript.compile(wrapped, bare: true)
        fn = Function(code)()

        return fn

      self.fn = O ->
        try
          compile()

      self.fn.error = O ->
        try
          compile()
        catch error
          error

      self
