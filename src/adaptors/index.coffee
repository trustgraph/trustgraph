{ json, log, p, pjson } = require 'lightsaber'
{ isEmpty, values } = require 'lodash'
neo4j = require './neo4j'
Ipfs = require './ipfs'

class Adaptors
  configure: (adaptors) ->
    @adaptors = {}
    return @autoConfigure() if not adaptors?
    for type, connection of adaptors
      try
        adaptor = require "./#{type}"
        @adaptors[type] = new adaptor {connection}
      catch e
        console.error "Unable to create Trust Exchange adaptor '#{type}':
          #{e}\n#{e.stack}"

  autoConfigure: ->
    Ipfs.create()
      .catch (err) => console.warn "IPFS not found: #{err}"
      .then (@ipfs) => @ipfs
      .then => neo4j.create()
      .catch (err) => console.warn "Neo4j not found: #{err}"
      .then (@neo4j) => @neo4j
      .then =>
        @adaptors.ipfs = @ipfs if @ipfs
        @adaptors.neo4j = @neo4j if @neo4j
        @report()
        return @
      .catch (e) =>
        console.error e

  report: ->
    adaptors = @get()
    log "Loaded adaptors:\n"
    for adaptor in adaptors
      log "  - #{adaptor.FULL_NAME}\n"

  get: (type) ->
    if type?
      @adaptors[type] ? throw new Error "#{type} adaptor not found"
    else if not @adaptors?
      throw new Error "Adaptors have not been configured, please call #configure(...) first"
    else if isEmpty @adaptors
      throw new Error "No adaptors found"
    else
      values @adaptors

instance = new Adaptors
module.exports = instance
