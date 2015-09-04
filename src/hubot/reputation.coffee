# Commands:
#   hubot rate <person> <value>% on <description>
#   hubot show reputation of <person>

{log, p, pjson} = require 'lightsaber'

Claim           = require '../../src/models/claim'
Reputation      = require '../../src/models/reputation'

ReputationBotCommands = (robot) ->

  robot.respond /show reputation of (.+)$/i, (msg) ->
    identity = msg.match[1]
    Reputation.report identity
      .then (report) => msg.send report

  robot.respond /rate (.+) ([\d.]+)% (?:at |on )(.+?)$/i, (msg) ->
    msg.match.shift()
    [target, value, content] = msg.match
    value *= 0.01  # convert to percentage

    source = robot.whose msg
    Claim.put { source, target, value, content }
      .then (messages) ->
        replies = for message in messages
          "Rating saved to #{message}"
        msg.send replies.join "\n"

module.exports = ReputationBotCommands
