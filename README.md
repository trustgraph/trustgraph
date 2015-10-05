# Trust Exchange

Latest build: [![Circle CI](https://circleci.com/gh/citizencode/trust-exchange/tree/master.svg?style=svg)](https://circleci.com/gh/citizencode/trust-exchange/tree/master)

Trust Exchange is:
  - An open protocol
  - A toolkit for building and reading distributed trust graphs
  - An ambitious plan to create interoperability between existing and future trust networks
  - Compatible with existing rating schemes (scores, percentages, star ratings, etc)
  - Open Source (MIT licensed)

![Trust Network Example](https://cdn.rawgit.com/citizencode/trust-exchange/fee63549abcaa480ee18da207ebab7c45321de84/doc/images/network.png)

Trust Exchange is a very young codebase, so expect limited functionality, and don't use it in production just yet.

## Protocol: Trust Atoms

Trust Exchange is composed entirely of `Trust Atoms`, an intentionally open format which can naturally represent ratings and "vouches", as well as substantially more esoteric formats.

A `Trust Atom` is a map of keys and values.  The only required keys are `source` and `target`; all others are optional.  Note that implementors may add other fields as needed -- we recommend starting custom field names with an underscore to avoid any naming collisions in the future.

```
{
  source: <hash of public key of the rater (person or organization)>
  target: <hash of public key, or URL of the entity being rated>
  value: <a numeric value in the range 0..1>
  content: <description or tags relating to rating>
  timestamp: <date/time of creation>
  +hash: <cryptographic hash of canonical JSON version of this trust atom>
  +signature: <cryptographic signature of hash, signed with the private key of source>
}
```

- `Source` is the hash of the public key of the person or organization doing the rating.
- `Target` is the person, organization, or entity being rated.  This may be:
  - The hash of the public key if available
  - A URL referring to the target
  - Another unique identifier of the target
- `Value` is a number which must be in the range 0..1 -- this may be the normalized form of:
    - a boolean (eg “upvote” or “like”)
    - rating in the form of 1-5 stars
    - a percentage score
- `content` is any semantic information related to the rating, which may be a description, tags, or any other text
- `Canocial JSON` is a JSON map of the existing fields:
  - omitting `+signature` and `+hash` (both of which rely on the `canonical JSON` itself)
  - omitting any fields whose value is empty
  - sorting the map by key
  - returning the minified resulting JSON
- `+Hash` is a cryptographic hash of `canocial JSON`, which may be used as a content ID
- `+Signature` is the result of cryptographically signing the `+hash` with the private key of the `source` (that key which is paired with the `source` public key)

A simple example, expressed in JSON, with only the required fields:

```json
{
  "source": "multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/"
}
```

This simply means "I am aware of the website at http://ipfs.io/", and does not confer any particular trust or rating information.

A fuller example using all currently defined fields:

```json
{
  "source": "multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/",
  "value": 0.99,
  "content": "content addressable graph infrastructure",
  "timestamp": "2015-08-11T22:32:23.207Z",
  "+hash": "multihash-QmaGJwJRTrYGChugJrdzUqq7CxwsvNyYuhUPZFvxuJUgtM",
  "+signature":"7de52c8bd7ec15fa117dca2ca9d6e474746316508337856f0b2e42617670a113845c0f98c34b833869ae47757659fb7051cf13c38c3cd3cba40cb89735c6a48c"
}
```

An example of a "like" as a Trust Atom:

```json
{
  "source": "multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/",
  "content": "like",
  "timestamp": "2015-08-11T22:32:23.207Z"
}
```

Using the example above, the `canonical JSON` would be:

```json
{"content":"content addressable graph infrastructure","value":0.99,"source":"multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target":"http://ipfs.io/"}
```

The `+hash` is created by applying a hashing function to the `canonical JSON`, which provides a permanent identifier (address) of this Trust Atom, eg:

```
multihash-QmemzKk3wiXjNVNrtdj7Mos11dNYzMFbxkfNQJ6W25CwLb
```

The creator of the `Trust Atom` can then sign this hash with the private key corresponding to the public key embedded in the Trust Atom itself.

## Local development

Start a local neo4j instance.  Then you can start the bot locally by running:

    npm run dev

If you wish to load environment variables from a local `.env` file:

```
env `cat .env` npm run dev
```

### IPFS

If you would like to point to a local IPFS daemon, try adding this line to your
`.env` file:

```
IPFS_HOST=/ip4/127.0.0.1/tcp/5001
```

## Project History

The original vision for Trust Exchange was landed and anchored in 2006 by
[Harlan T Wood](https://github.com/harlantwood),
[Adam Apollo](http://www.adamapollo.com/),
and [Jack Senechal](https://github.com/jacksenechal),
and subsequently published on the
[Enlightened Structure](http://www.enlightenedstructure.net/#/Trust-Exchange)
site.

Harlan met [Noah Thorp](https://twitter.com/noahthorp) in 2007,
and their very first conversation revolved around this kind
of trust technology.  Noah and Harlan worked together on various projects,
and in July 2015 were together at [Citizen Code](http://www.citizencode.io/), along with [Joel Dietz](http://fractastical.com/),
who had previously designed and written about systems for trust, including
"[green ether](https://github.com/fractastical/etherea/blob/master/green_ether.md)".

Harlan, Joel, and Noah decided to create an open source, permissively licensed,
reference implementation of Trust Exchange, as a foundation for free, open,
interoperable trust systems.  Their plan was enthusiastically supported by
Adam and Jack, and in August 2015 this version of Trust Exchange was born.

## See Also

- Hubot: https://hubot.github.com/docs/
- Neo4J: http://neo4j.com/docs/stable/
- Multihash: https://github.com/jbenet/multihash
