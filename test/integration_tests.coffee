chai = require 'chai'
chai.should()

{db} = require '../src/adaptors/neo4j/db'
Claim = require '../src/models/claim'
Reputation = require '../src/models/reputation'

# TODO DON'T KILL ALL LOCAL NEO4J DATA -- MAYBE PREFIX
DESTROY_ALL = 'MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r'

describe 'Reputation', ->
  beforeEach (done) ->
    db.cypher query: DESTROY_ALL, (error, results) ->
      if error
        throw error
      else
        done()

  it 'should allow users to add and query reputation for other users', (done) ->
    rating =
      source: '@jack'
      target: '@jill'
      value: 0.95,
      content: 'water services'

    Claim.put rating, -> #log pjson arguments
      Reputation.stats '@jill', (stats) ->
        stats.should.deep.equal [ rating ]
        done()
