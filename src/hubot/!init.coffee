# Commands:

{ json, log, p, pjson } = require 'lightsaber'
trustExchange = require '../models/trustExchange'

InitBot = (robot) ->

  trustExchange.configure()

  throw new Error if robot.whose?

  robot.whose = (message) -> "@#{message.message.user.name}"

module.exports = InitBot
