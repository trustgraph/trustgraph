# Commands:
#   hubot load demo data

{log, p, pjson} = require 'lightsaber'
Loader          = require '../db/loader'

DbBot = (robot) ->

  robot.respond /load demo data$/i, (msg) ->
    Loader.demoDataTrustNetwork (data) -> msg.send "Loaded.\n" + data

module.exports = DbBot
