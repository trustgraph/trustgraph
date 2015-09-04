{log, p, pjson} = require 'lightsaber'

{db, params} = require '../adaptors/neo4j'

{nodes, links} = require './fixtures/les-mis'
Claim          = require '../models/claim'

class Loader

  @demoDataTrustNetwork: (callback) ->
    for link in links
      source = nodes[link.source].name
      target = nodes[link.target].name
      value = link.value
      Claim.put { source, target, value }, (results) ->
        log pjson results

module.exports = Loader
