# Trust Exchange

Trust Exchange is:
  - An open protocol
  - A toolkit for building and reading distributed trust graphs
  - An ambitious plan to create interoperability between existing and future trust networks
  - Compatible with existing rating schemes (scores, percentages, star ratings, etc)
  - Open Source (MIT licensed)

Trust Exchange is a very young codebase, so expect limited functionality, and don't use it in production just yet.

Trust Exchange is composed entirely of `Trust Atoms`, an intentionally open format which can naturally represent ratings and "vouches", as well as substantially more esoteric formats.

A `Trust Atom` is a map of keys and values.  The only required keys are `source` and `target`; all others are optional.

- `Source` is the hash of the public key of the person or organization doing the rating.
- `Target` is the person, organization, or entity being rated.  This may be:
  - The hash of the public key if available
  - A URL referring to the target
  - Another unique identifier of the target
- `Value` is a number which must be in the range 0..1.  
  - In most cases this will be the normalized form of:
    1. a boolean (eg “upvote” or “like”)
    1. rating in the form of 1-5 stars
    1. a percentage score
  - If `value` is omitted, a default value of 0.5 may be assumed
- `Description` is any semantic information related to the rating, which may be a description, tags, or any other text
- `Canocial JSON` is a JSON map of the existing fields:
  - omitting `signature` and `hash` (both of which rely on the `canonical JSON` itself)
  - omitting any fields whose value is empty
  - sorting the map by key
  - returning the minified resulting JSON
- `Hash` is a cryptographic hash of `canocial JSON`, which may be used as a content ID
- `Signature` is the result of cryptographically signing the `hash` with the private key of the `source` (that key which is paired with the `source` pubic key)

A concrete example, expressed in JSON:

```json
{
  "source": "multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/",
  "value": 0.99,
  "description": "content addressable graph infrastructure",
  "timestamp": "2015-08-11T22:32:23.207Z",
  "signature":"7de52c8bd7ec15fa117dca2ca9d6e474746316508337856f0b2e42617670a113845c0f98c34b833869ae47757659fb7051cf13c38c3cd3cba40cb89735c6a48c",
  "hash": "multihash-QmaGJwJRTrYGChugJrdzUqq7CxwsvNyYuhUPZFvxuJUgtM"
}
```

Using the example above, the `canonical JSON` would be:

```json
{"description":"content addressable graph infrastructure","rating":0.99,"source":"multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target":"http://ipfs.io/"}
```

The `hash` is created by applying a hashing function to the `canonical JSON`, which provides a permanent identifier (address) of this Trust Atom, eg:

```
multihash-QmemzKk3wiXjNVNrtdj7Mos11dNYzMFbxkfNQJ6W25CwLb
```

The creator of the rating can then sign this hash with the private key corresponding to the public key embedded in the rating itself.

## Local development

Start a local neo4j instance.  Then you can start the bot locally by running:

    npm run dev

## Continuous Ingtegration

Build: [![Circle CI](https://circleci.com/gh/citizencode/trust-exchange/tree/master.svg?style=svg)](https://circleci.com/gh/citizencode/trust-exchange/tree/master)

## Hubot Notes

- https://hubot.github.com/docs/

## Neo4J Notes

- http://neo4j.com/docs/stable/

## See Also

- https://github.com/jbenet/multihash
