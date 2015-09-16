{log, p, pjson} = require 'lightsaber'
{ first, flatten, unique, pluck, round, sum } = require 'lodash'
Promise = require 'bluebird'
trustExchange = require './trustExchange'

class Reputation

  @ratingsOf: (identity, options) ->
    ratingSets = for adaptor in trustExchange.adaptors()
      adaptor.ratingsOf identity, options
    Promise.all ratingSets
      .then (ratingSets) -> unique flatten ratingSets

  @score: (identity, options) ->
    @ratingsOf identity, options
    .then (ratings) ->
      ratingValues = pluck(ratings, 'value')
      round(sum(ratingValues) / ratingValues.length * 100) if ratingValues.length > 0

  @report: (identity, options) ->
    @ratingsOf identity, options
      .then (ratings) =>
        reportLines = for {source, target, value, content} in ratings
          value *= 100
          "  - #{value}% #{content} (from #{source})"
        report = if reportLines.length > 0
          "#{identity} has ratings:\n#{reportLines.join "\n"}"
        else
          "#{identity} does not yet have any ratings..."

module.exports = Reputation
