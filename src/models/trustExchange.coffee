{ json, log, p, pjson } = require 'lightsaber'
adaptors = require '../adaptors'

class TrustExchange

  constructor: -> @_adaptors = adaptors

  configure: (args) -> @_adaptors.configure args?.adaptors

  adaptors: -> @_adaptors.get()

module.exports = new TrustExchange
