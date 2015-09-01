{log, p, pjson} = require 'lightsaber'
neo4j = require 'neo4j'

db = new neo4j.GraphDatabase
  url: process.env['NEO4J_URL'] || process.env['GRAPHENEDB_URL'] || 'http://neo4j:neo4j@localhost:7474'
  auth: process.env['NEO4J_AUTH']

db.cypher { query: 'return 0' }, (error, results) ->
  if error?.code is 'ECONNREFUSED'
    console.error "Can't connect to Neo4J: make sure server is running locally, or NEO4J_URL environment variable is set"
    process.exit 1

isConstraintViolation = (err) ->
  err instanceof neo4j.ClientError &&
    err.neo4j.code is 'Neo.ClientError.Schema.ConstraintViolation'

params = ({quoted, plain}) ->
  quotedPairs = for propKey, propValue of quoted when propKey? and propValue?
    "#{propKey}: '#{propValue}'"
  plainPairs = for propKey, propValue of plain when propKey? and propValue?
    "#{propKey}: #{propValue}"
  pairs = quotedPairs.concat plainPairs
  "{#{pairs.join ', '}}"

module.exports = {
  db
  params
  isConstraintViolation
}
