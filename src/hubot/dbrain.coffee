# Commands:

#   hubot create neuron - <data>
#   hubot create <hash> neuron - <data>
#   hubot rate <hash> neuron <rating>%


{log, p, pjson} = require 'lightsaber'

Neuron      = require '../models/neuron'

DBrainBotCommands = (robot) ->

  robot.respond /create neuron - (.+)$/i, (msg) ->

    msg.match.shift()
    [data] = msg.match
    source = "@#{msg.message.user.name}";
    Neuron.put { source, "yo", data }, ->
      log pjson arguments
      msg.send "Created."

  robot.respond /create (.+) neuron - (.+)$/i, (msg) ->

    msg.match.shift()
    [hash, data] = msg.match
    source = "@#{msg.message.user.name}";
    Neuron.put { source, hash, data }, ->
      log pjson arguments
      msg.send "Created."

  robot.respond /rate (.+) neuron ([\d.]+)%$/i, (msg) ->

    msg.match.shift()
    [hash, rating] = msg.match
    rating *= 0.01  # convert to percentage
    source = "@#{msg.message.user.name}";

    Claim.put { source, hash, rating }, ->
      log pjson arguments
      msg.send "Rated."

module.exports = DBrainBotCommands
