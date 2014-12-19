Transducer
==========

A generalized data transformation

    Model = require "./model"
    O = require "o_0"
    {defaults} = require "./util"

    NULL = (input) ->

    partition = (predicate) ->
      (left, right) ->
        (input) ->
          if predicate.call(input, input)
            left input
          else
            right input

    filter = (predicate) ->
      (output) ->
        partition(predicate)(output, NULL)

    each = (output) ->
      (input) ->
        [].concat(input).forEach output

    map = (f) ->
      (output) ->
        (input) ->
          output f.call(input, input)

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        source: """
          @id
        """

      self.attrObservable """
        source
        type
        title
      """.split(/\s+/)...

      compile = ->
        indent = /^/m
        wrapped = "return ->\n" + self.source().replace indent, "  "
        code = CoffeeScript.compile(wrapped, bare: true)
        fn = Function(code)()

        return fn

      self.pipe = ->
        switch self.type()
          when "mapping"
            map self.fn()
          when "filter"
            filter self.fn()
          when "expansion"
            each
          when "edit"
            ;

      self.fn = O ->
        try
          compile()

      self.fn.error = O ->
        try
          compile()
        catch error
          error

      self
