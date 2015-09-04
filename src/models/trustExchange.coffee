{ json, log, p, pjson } = require 'lightsaber'
adaptors = require '../adaptors'

class TrustExchange

  constructor: ->
    @_adaptors = adaptors

  configure: ->
    @_adaptors.configure()

  adaptors: -> @_adaptors.get()

module.exports = new TrustExchange
