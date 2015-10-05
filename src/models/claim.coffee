{log, p, pjson} = require 'lightsaber'
Promise = require 'bluebird'
trustExchange = require './trustExchange'

class Claim
  @put: (trustAtom, options) ->
    results = for adaptor in trustExchange.adaptors()
      adaptor.putClaim trustAtom, options
    Promise.all results

module.exports = Claim
