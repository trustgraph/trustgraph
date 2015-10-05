Fs   = require 'fs'
Path = require 'path'

hubotModule = (robot) ->
  path = Path.resolve __dirname, 'hubot'
  Fs.exists path, (exists) ->
    if exists
      robot.loadFile path, file for file in Fs.readdirSync(path)

# Allow inclusion as a hubot external script:
module.exports = hubotModule

# Export core libraries
module.exports.Claim = require './models/claim'
module.exports.Reputation = require './models/reputation'
module.exports.instance = require './models/trustExchange'
