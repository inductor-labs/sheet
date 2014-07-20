Sheet
=====

One sheet of data transforms.

    Model = require "./model"

    compile = require "./compile"

    O = require "o_0"

    add = (a, b) ->
      a + b

    ADDITIVE_IDENTITY = 0
    sum = (arr) ->
      arr.reduce(add, ADDITIVE_IDENTITY)

    map = (arr, fn) ->
      arr.map (item) ->
        fn.call(item, item)

    module.exports = (I={}, self=Model(I)) ->
      defaults I,
        sourceUrl: "https://api.github.com/gists"
        mapTransform: "@id, @url, @owner.id"
        reduceTransform: "@owner.id"
        data: []

      self.attrObservable """
        data
        mapTransform
        reduceTransform
        sourceUrl
      """.split(/\s+/)...

      self.extend
        applyMapping: ->
          $.getJSON(@sourceUrl()).then(@data)

        prettyPrintData: ->
          JSON.stringify @data(), null, 2

        headers: ->
          self.mapTransform().split(",")

        mapping: ->
          compile self.mapTransform()

        body: ->
          map(self.data, self.mapping())

        reduction: ->
          t = compile self.reduceTransform()

          sum map(@data, t)

Helpers
-------

    defaults = (target, objects...) ->
      for object in objects
        for name of object
          unless target.hasOwnProperty(name)
            target[name] = object[name]

      return target
