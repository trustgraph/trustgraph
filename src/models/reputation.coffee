{log, p, pjson} = require 'lightsaber'
{db, params} = require '../db/neo4j'

class Reputation

  @report: (identity, callback) ->
    @stats identity, (ratings) ->
      reportLines = for {source, target, value, content} in ratings
        value *= 100
        "  - #{value}% #{content} (from #{source})"
      report = if reportLines.length > 0
        "#{identity} has ratings:\n#{reportLines.join "\n"}"
      else
        "#{identity} does not yet have any ratings..."
      callback report

  @stats: (identity, callback) ->
    targetParams = params quoted: {key: identity}
    query = """
      MATCH (source)
      MATCH (target:Identity #{targetParams})
      MATCH (source) -[rating:RATES]-> (target)
      RETURN source, rating
    """

    db.cypher { query }, (error, results) ->
      throw error if error
      ratings = for result in results
        source: result.source.properties.key
        target: identity
        value: result.rating.properties.value
        content: result.rating.properties.content
      callback ratings

module.exports = Reputation
