{log, p, pjson} = require 'lightsaber'

{db, params} = require '../db/neo4j'

class Claim

  @put: (props, callback) ->
    { source, target, value, content } = props
    ratingParams = params quoted: { content }, plain: { value, timestamp: 'timestamp()' }
    query = """
      MERGE (source:Identity { key: '#{source}' })
      MERGE (target:Identity { key: '#{target}' })
      MERGE (source)-[rating:RATES #{ratingParams}]->(target)
      RETURN source, target, rating
      """

    db.cypher { query }, (error, results) ->
      throw error if error
      callback results

module.exports = Claim
