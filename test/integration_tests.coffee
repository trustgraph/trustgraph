{log, p, pjson} = require 'lightsaber'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
chai.use chaiAsPromised
chai.should()

neo4j = require '../src/adaptors/neo4j'
Claim = require '../src/models/claim'
Reputation = require '../src/models/reputation'
trustExchange = require '../src/models/trustExchange'

# TODO DON'T KILL ALL LOCAL NEO4J DATA -- MAYBE PREFIX
DESTROY_ALL = 'MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r'

describe 'Reputation', ->
  before (done) ->
    trustExchange.configure()
      .then (adaptors) => adaptors.get('neo4j').cypher query: DESTROY_ALL
      .catch (error) => console.error error
      .then -> done()

  it 'should allow users to add and query reputation for other users', ->
    rating =
      source: '@jack'
      target: '@jill'
      value: 0.95,
      content: 'water services'
    Claim.put rating
      .then => Reputation.ratingsOf('@jill').should.eventually.deep.equal [rating]
