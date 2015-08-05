# Description:
#   Reputation commands
#
# Commands:
#   hubot rate <person> <value>% on <description>
#   hubot show reputation of <person>
#

{log, p, pjson} = require 'lightsaber'

Claim           = require '../../src/models/claim'
Reputation      = require '../../src/models/reputation'
{currentUser}   = require './helpers/user'

ReputationBotCommands = (robot) ->

  robot.respond /show reputation of (.+)/i, (msg) ->
    identity = msg.match[1]
    Reputation.report identity, (report) ->
      msg.send report

  robot.respond /rate (.+) ([\d.]+)% (?:at|on) (.+)/i, (msg) ->
    msg.match.shift()
    [target, value, content] = msg.match
    value *= 0.01  # convert to percentage

    source = currentUser msg
    Claim.put { source, target, value, content }, ->
      msg.send "Rated."

module.exports = ReputationBotCommands
