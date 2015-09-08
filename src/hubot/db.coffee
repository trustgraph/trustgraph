# Commands:
#   hubot load demo data

{log, p, pjson} = require 'lightsaber'
Loader          = require '../db/loader'

DbBot = (robot) ->

  robot.respond /load demo data$/i, (msg) ->
    Loader.demoData()
      .then (replies) => msg.send "Loaded.\n" + replies.join "\n"

module.exports = DbBot
