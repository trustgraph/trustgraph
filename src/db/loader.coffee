{log, p, pjson} = require 'lightsaber'

{db, params} = require './neo4j'

class Loader

  @demoDataTrustNetwork: (callback) ->

    # log query = """
    #
    #   // DELETES ALL DATA, BE CAREFUL!!!
    #   MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r
    #
    #   MERGE (p1:Person {key: "@monty"})
    #   MERGE (p2:Person {key: "@alice"})
    #   MERGE (p3:Person {key: "@luke"})
    #   MERGE (p4:Person {key: "@peter"})
    #   MERGE (p5:Person {key: "@harry"})
    #   MERGE (p6:Person {key: "@sue"})
    #   MERGE (p7:Person {key: "@venessa"})
    #
    #   MERGE (p1) -[r1:RATES {value: 0.8, content: "trustworthy"} ]-> (p2)
    #   MERGE (p1) -[r2:RATES {value: 0.2, content: "trustworthy"} ]-> (p3)
    #   MERGE (p1) -[r3:RATES {value: 0.2, content: "trustworthy"} ]-> (p4)
    #   MERGE (p2) -[r4:RATES {value: 0.2, content: "trustworthy"} ]-> (p5)
    #   MERGE (p2) -[r5:RATES {value: 0.2, content: "trustworthy"} ]-> (p6)
    #   MERGE (p2) -[r6:RATES {value: 0.2, content: "trustworthy"} ]-> (p7)
    #
    #   """

    db.cypher { query }, (error, results) ->
      throw error if error
      callback results

module.exports = Loader
