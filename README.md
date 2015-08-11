# Trust Exchange

Trust Exchange is:
  - An open protocol
  - A toolkit for building and reading distributed trust graphs
  - An ambitious plan to create interoperability between existing and future trust networks
  - Compatible with existing rating schemes (scores, percentages, star ratings, etc)
  - Open Source (MIT licensed)

Trust Exchange is a very young codebase, so expect limited functionality, and don't use it in production just yet.

Trust Exchange is composed entirely of _Trust Atoms_, an intentionally open format which can naturally represent ratings and "vouches", as well as substantially more esoteric formats.

A _Trust Atom_ is a map of keys and values.  The only required keys are _source_ and _target_; all others are optional.

- _Source_ is the hash of the public key of the person or organization doing the rating.
- _Target_ is the person, organization, or entity being rated.  This may be:
  - The hash of the public key if available
  - A URL referring to the target
  - Another unique identifier of the target
- _Value_ is a number which must be in the range 0..1.  
  - In most cases this will be the normalized form of:
    1. a boolean (eg “upvote” or “like”)
    1. rating in the form of 1-5 stars
    1. a percentage score
  - If _value_ is omitted, a default value of 0.5 may be assumed
- _Description_ is any semantic information related to the rating, which may be a description, tags, or any other text
- _Canocial JSON_ is a JSON map of the existing fields:
  - omitting _signature_ and _hash_ (both of which rely on the _canonical JSON_ itself)
  - omitting any fields whose value is empty
  - sorting the map by key
  - returning the minified resulting JSON
- _Hash_ is a cryptographic hash of _canocial JSON_, which may be used as a content ID
- _Signature_ is the result of cryptographically signing the _hash_ with the private key of the _source_ (that key which is paired with the _source_ pubic key)

Using the example above, the _canonical JSON_ would be:

```json
{"description":"content addressable graph infrastructure","rating":0.99,"source":"multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target":"http://ipfs.io/"}
```

The _hash_ is created by applying a hashing function to the _canonical JSON_, which provides a permanent identifier (address) of this Trust Atom, eg:

`multihash-QmemzKk3wiXjNVNrtdj7Mos11dNYzMFbxkfNQJ6W25CwLb`

The creator of the rating can then sign this hash with the private key corresponding to the public key embedded in the rating itself.

## CI

Build: [![Circle CI](https://circleci.com/gh/citizencode/trust-exchange/tree/master.svg?style=svg)](https://circleci.com/gh/citizencode/trust-exchange/tree/master)

## Local development

Start a local neo4j instance.  Then you can start the bot locally by running:

    npm run dev

## Hubot Notes

- https://hubot.github.com/docs/

## Neo4J Notes

- http://neo4j.com/docs/stable/

## See Also

- https://github.com/jbenet/multihash
