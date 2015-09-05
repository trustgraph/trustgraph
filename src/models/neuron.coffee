# {log, p, pjson} = require 'lightsaber'
#
# {db, params} = require '../adaptors/neo4j'
#
# class Neuron
#
#   @put: (props, callback) ->
#     { source, hash, data } = props
#     log query = """
#       MERGE (source:Identity { key: '#{source}' })
#       MERGE (neuron:Neuron {key : '#{hash}', data: '#{data}'} )
#       CREATE UNIQUE (source)-[offer:OFFER]->(neuron)
#       RETURN source, neuron, offer
#       """
#
#     db.cypher { query }, (error, results) ->
#       throw error if error
#       callback results
#
# module.exports = Neuron
