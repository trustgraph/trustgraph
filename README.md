# ŦRUSŦ GRΔPH

Trust Graph is:
  - An open protocol
  - A toolkit for building and reading distributed trust graphs
  - An ambitious plan to create interoperability between existing and future trust networks
  - Compatible with existing rating schemes (scores, percentages, star ratings, etc)
  - Open Source (Apache 2 licensed)

![Trust Network Example](https://cdn.rawgit.com/trustgraph/trustgraph/fee63549abcaa480ee18da207ebab7c45321de84/doc/images/network.png)

Trust Graph is a very young codebase, so expect limited functionality, and don't use it in production just yet.

## Why Trust Graph?

In 1963 J.C.R. Licklider, director of the Information Processing Techniques Office at The Pentagon's Advanced Research Projects Agency, proposed an "[Intergalactic Computer Network](https://en.wikipedia.org/wiki/Intergalactic_Computer_Network)", which he envisioned as an electronic commons open to all.  This bold vision planted the seeds for ARPANET, and eventually for the network of networks known as the Internet.  Today we need an equally bold vision -- an open interoperable commons for the permanent storage, sharing, and searching of what is perhaps the most important information of our time: Trust.

## Features

What is meant mean by a "Permanent Open Trust Network"?  Here we refer to a permanent digital archive for trust, reputation, and ratings information, which has the characteristics:

1. Anyone can contribute _claims_ (collectively representing any type of trust or reputation data: ratings, vouches, "likes", reviews, etc)

1. Claims are in an open format that is sufficiently flexible to represent multiple claim types

1. Claims are immutable, and cryptographically signed by a private key belonging to the claimant

1. A claim can target any person or entity, commonly a public key (if available) or a URL

1. Claims can be easily shared, selectively or publicly, or may remain private

1. A _trust network_ thereby emerges for each claimant, which is actually a cascading network of the trust networks they are most closely connected to

1. Information within such a trust network is easily discoverable and  searchable

## Trust Graph Architecture

Here we address the technical components implied by the features listed above, and indicate the external software, or internal directions intended by Trust Graph.

### Extensible & Interoperable

Trust Graph aims for maximum extensibility and ecosystem compatibility:

1. Pluggable datastores: the reference implementation currently uses a graph database and IPFS, and is designed to support other storage backends as well
1. Data architecture supports interoperability with [JSON-LD](http://json-ld.org) [Verifiable Claims](https://opencreds.github.io/vc-data-model/#expressing-entity-credentials-in-json), RDF, and [IETF Reputons](https://tools.ietf.org/html/rfc7071), among others
1. Open architecture for multiple cryptographic hashing, signing, and encryption  algorithms

### Protocol: Trust Atoms

Trust Graph is composed entirely of `Trust Atoms`, an intentionally open format which can naturally represent ratings and "vouches", as well as substantially more esoteric formats.

A `Trust Atom` is a map of keys and values.  The only required keys are `source` and `target`; all others are optional.  Implementors may add other fields as needed.

```
{
  source: <hash of public key of the rater (person or organization)>
  target: <hash of public key, or URL of the entity being rated>
  value: <a numeric value in the range 0..1>
  content: <description or tags relating to rating>
  timestamp: <date/time of creation>
}
```

- `source` is the hash of the public key of the person or organization doing the rating.
- `target` is the person, organization, or entity being rated.  This may be:
  - The hash of the public key if available
  - A URL referring to the target
  - Another unique identifier of the target
- `value` is a number which must be in the range 0..1 -- this may be the normalized form of:
    - a boolean (eg “upvote” or “like”)
    - rating in the form of 1-5 stars
    - a percentage score
- `content` is any semantic information related to the rating, which may be a description, tags, or any other text

A simple example:

```json
{
  "source": "QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/",
  "value": 0.99,
  "content": "content addressable graph infrastructure",
  "timestamp": "2015-08-11T22:32:23.207Z",
}
```

### Usage

#### Create Claims

Using the command line tools to create a claim:

```
trust claim --help

Usage: trust-claim [options]

  Options:

    -h, --help                   output usage information
    --creator <creator>          DID or URL of claim creator
    --target <target>            DID or URL of claim target
    --description <description>  Rating description
    --tags <tag1, tag2>          Rating tags
    --value <value>              Rating weight in the range 0..1
    --algorithm <algorithm>      Signing algorithm
    --private-key <key>          Private key
```

For example:

```
trust claim \
  --creator did:00a65b11-593c-4a46-bf64-8b83f3ef698f \
  --target did:59f269a0-0847-4f00-8c4c-26d84e6714c4 \
  --description 'Elixir programming' \
  --value 0.99 \
  --tags 'programming, Elixir' \
  --algorithm EcdsaKoblitzSignature2016 \
  --private-key L4mEi7eEdTNNFQEWaa7JhUKAbtHdVvByGAqvpJKC53mfiqunjBjw
```

Creates the following signed JSON, in the [JSON-LD Verifiable Claim](https://opencreds.github.io/vc-data-model/#expressing-entity-credentials-in-json) format.

```json
{
    "@context": "https://schema.trustgraph.io/TrustClaim.jsonld",
    "type": "TrustClaim",
    "issuer": "did:00a65b11-593c-4a46-bf64-8b83f3ef698f",
    "issued": "2017-03-04T02:05:07-08:00",
    "claim": {
        "@context": "https://schema.org/",
        "type": "Review",
        "itemReviewed": "did:59f269a0-0847-4f00-8c4c-26d84e6714c4",
        "author": "did:00a65b11-593c-4a46-bf64-8b83f3ef698f",
        "keywords": "programming, Elixir",
        "reviewRating": {
            "@context": "https://schema.org/",
            "type": "Rating",
            "bestRating": 1,
            "worstRating": 0,
            "ratingValue": "0.99",
            "description": "Elixir programming"
        }
    },
    "signature": {
        "type": "sec:EcdsaKoblitzSignature2016",
        "http://purl.org/dc/terms/created": {
            "type": "http://www.w3.org/2001/XMLSchema#dateTime",
            "@value": "2017-03-04T10:05:07Z"
        },
        "http://purl.org/dc/terms/creator": {
            "id": "EcdsaKoblitz-public-key:020d79074ef137d4f338c2e6bef2a49c618109eccf1cd01ccc3286634789baef4b"
        },
        "sec:domain": "example.com",
        "signature:Value": "IEd/NpCGX7cRe4wc1xh3o4X/y37pY4tOdt8WbYnaGw/Gbr2Oz7GqtkbYE8dxfxjFFYCrISPJGbBNFyaiVBAb6bs="
    }
}
```

We canonicalize the JSON, by minifying and sorting hashes by keys:

```json
{"@context":"https://schema.trustgraph.io/TrustClaim.jsonld","claim":{"@context":"https://schema.org/","author":"did:00a65b11-593c-4a46-bf64-8b83f3ef698f","itemReviewed":"did:59f269a0-0847-4f00-8c4c-26d84e6714c4","keywords":"programming, Elixir","reviewRating":{"@context":"https://schema.org/","bestRating":1,"description":"Elixir programming","ratingValue":"0.99","type":"Rating","worstRating":0},"type":"Review"},"issued":"2017-03-04T02:05:07-08:00","issuer":"did:00a65b11-593c-4a46-bf64-8b83f3ef698f","signature":{"http://purl.org/dc/terms/created":{"@value":"2017-03-04T10:05:07Z","type":"http://www.w3.org/2001/XMLSchema#dateTime"},"http://purl.org/dc/terms/creator":{"id":"EcdsaKoblitz-public-key:020d79074ef137d4f338c2e6bef2a49c618109eccf1cd01ccc3286634789baef4b"},"sec:domain":"example.com","signature:Value":"IEd/NpCGX7cRe4wc1xh3o4X/y37pY4tOdt8WbYnaGw/Gbr2Oz7GqtkbYE8dxfxjFFYCrISPJGbBNFyaiVBAb6bs=","type":"sec:EcdsaKoblitzSignature2016"},"type":"TrustClaim"}
```

Then hash the canonical JSON to get an ID for the claim:

```
QmbVYv7Zih44uJ8MAcpxQ3TZGKUscNoYyK6UKUaut6jK77  # sha2-256 multihash
```

#### Retrieve Claims

Retrieve and analyze a collection of ratings.

_NOTE: not yet implemented!
Below is an API sketch; please submit any
comments or requests as Github issues._

```
trust map --help

Usage: trust-map [options]

  Options:

    -h, --help           output usage information
    --perspective <DID>  Perspective (identity) through which trust network is seen
    --creator <creator>  DID or URL of claim creator
    --target <target>    DID or URI of claim target
    --tags <tag1, tag2>  Filter by tags
    --depth <levels>     Crawls trust ratings to specified depth
    --min-value <value>  Min trust rating 0..1
    --max-value <value>  Max trust rating 0..1
    --summarize          Summarize claims / build analysis
    --falloff            Trust level relative to depth, eg: [1, 0.5, 0.33]
```

For example:

```
trust map \
  --target did:59f269a0-0847-4f00-8c4c-26d84e6714c4 \
  --tags 'programming, Elixir' \
```

## Demo

The best live demo that showcases much of our thinking and work to date is the  [Work.nation prototype](https://demo.worknation.io/), built by CoMakery, Cisco, uPort, and The Institute for The Future.  In this demo, your contributions to projects (e.g. Javascript, UX, etc) are verified by project team members. You can search for folks with the experience you need through the contributors you trust and the contributors they trust.

Work.nation uses decentralized identity (uPort), decentralized storage of reputation data (IPFS), and blockchain claim notarization (Ethereum). The [technical overview and open source code](https://github.com/worknation/work.nation) are on github.
