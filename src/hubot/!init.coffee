# Commands:

{ json, log, p, pjson } = require 'lightsaber'
TrustExchange = require '../models/trustExchange'

InitTrustExchange = (robot) ->
  TrustExchange.configure()
  robot.brain.set 'TX', TrustExchange

module.exports = InitTrustExchange
