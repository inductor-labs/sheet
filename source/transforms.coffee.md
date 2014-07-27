Transforms
==========

    O = require "o_0"

    map = (arr, fn) ->
      arr.map (item) ->
        fn.call(item, item)

    sort = (arr, fn) ->
      arr.concat([]).sort (a, b) ->
        fn.call(a, a) - fn.call(b, b)

    module.exports.map = map
    module.exports.sort = sort
