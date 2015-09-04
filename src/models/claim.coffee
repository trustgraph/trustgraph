{log, p, pjson} = require 'lightsaber'
Promise = require 'bluebird'
trustExchange = require './trustExchange'

class Claim
  @put: (trustAtom) ->
    results = for adaptor in trustExchange.adaptors()
      adaptor.putClaim trustAtom
    Promise.all results

module.exports = Claim
