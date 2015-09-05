{log, p, pjson} = require 'lightsaber'
Promise = require 'bluebird'
neo4j = require 'neo4j'

class Neo4jAdaptor
  FULL_NAME: "Neo4J"
  SHORT_NAME: Neo4jAdaptor::FULL_NAME

  @create: (args={}) ->
    db = new neo4j.GraphDatabase
      url: process.env['NEO4J_URL'] || process.env['GRAPHENEDB_URL'] || 'http://neo4j:neo4j@localhost:7474'
      auth: process.env['NEO4J_AUTH']
    db.cypherAsync = Promise.promisify db.cypher
    db.cypherAsync query: 'return 0'
      .catch (error) =>
        if error?.code is 'ECONNREFUSED'
          return Promise.reject "make sure server is running locally,
            and NEO4J_URL environment variable is set"
      .then => return new Neo4jAdaptor {db}

  constructor: ({@db}) ->
    unless @db instanceof neo4j.GraphDatabase
      throw new Error "try calling .create(...) if you called the constructor directly"

  cypher: -> @db.cypherAsync arguments...

  putClaim: (props, callback) ->
    { source, target, value, content } = props
    ratingParams = @params quoted: { content }, plain: { value, timestamp: 'timestamp()' }
    query = """
      MERGE (source:Identity { key: '#{source}' })
      MERGE (target:Identity { key: '#{target}' })
      MERGE (source)-[rating:RATES #{ratingParams}]->(target)
      RETURN source, target, rating
      """
    @cypher { query }
      .then (results) => @SHORT_NAME

  ratingsOf: (identity) ->
    targetParams = @params quoted: {key: identity}
    query = """
      MATCH (source)
      MATCH (target:Identity #{targetParams})
      MATCH (source) -[rating:RATES]-> (target)
      RETURN source, rating
    """
    @cypher { query }
      .then (results) =>
        ratings = for result in results
          source: result.source.properties.key
          target: identity
          value: result.rating.properties.value
          content: result.rating.properties.content

  isConstraintViolation: (err) ->
    err instanceof neo4j.ClientError &&
      err.neo4j.code is 'Neo.ClientError.Schema.ConstraintViolation'

  params: ({quoted, plain}) ->
    quotedPairs = for propKey, propValue of quoted when propKey? and propValue?
      "#{propKey}: '#{propValue}'"
    plainPairs = for propKey, propValue of plain when propKey? and propValue?
      "#{propKey}: #{propValue}"
    pairs = quotedPairs.concat plainPairs
    "{#{pairs.join ', '}}"

module.exports = Neo4jAdaptor
