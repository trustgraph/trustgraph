{log, p, pjson} = require 'lightsaber'
adaptors = require '../adaptors'

class Claim

  @put: (props, callback) ->
    for adaptor in adaptors
      adaptor.putClaim props, callback

module.exports = Claim
