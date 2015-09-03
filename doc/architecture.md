libs:

- trust-exchange 
  - core functions
  - datastores starting with neo4j and ipfs (either or both as available)
  
- hubot-trust-exchange
  - add reputation, check reputation
  - simple english interface
  - can be run with slack, twitter, or other hubot adaptor 

apps:

- trust-exchange-slackbot
  - uses hubot-trust-exchange lib
  - allows users to post & check reputation from slack
  
- trust-exchange-avatar
  - uses hubot-trust-exchange lib
  - runs as @Trust_Exchange
  - example:
    - @bob Tweets “@alice is a cultural maven #TrustExchange”
    - avatar says: "@alice you can manage your trust network at trustexchange.io"
    
