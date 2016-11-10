# Trust Exchange

Latest build: [![Circle CI](https://circleci.com/gh/CoMakery/trust-exchange/tree/master.svg?style=svg)](https://circleci.com/gh/CoMakery/trust-exchange/tree/master)

Trust Exchange is:
  - An open protocol
  - A toolkit for building and reading distributed trust graphs
  - An ambitious plan to create interoperability between existing and future trust networks
  - Compatible with existing rating schemes (scores, percentages, star ratings, etc)
  - Open Source (MIT licensed)

![Trust Network Example](https://cdn.rawgit.com/CoMakery/trust-exchange/fee63549abcaa480ee18da207ebab7c45321de84/doc/images/network.png)

Trust Exchange is a very young codebase, so expect limited functionality, and don't use it in production just yet.

## Protocol: Trust Atoms

Trust Exchange is composed entirely of `Trust Atoms`, an intentionally open format which can naturally represent ratings and "vouches", as well as substantially more esoteric formats.

## Usage

For example:

```
trust claim \
  --creator did:00a65b11-593c-4a46-bf64-8b83f3ef698f \
  --target did:59f269a0-0847-4f00-8c4c-26d84e6714c4 \
  --algorithm sha256-ecdsa-secp256k1 \
  --private-key L4mEi7eEdTNNFQEWaa7JhUKAbtHdVvByGAqvpJKC53mfiqunjBjw \
  --claim-summary 'Awesome paper!!!' \
  --tags 'Reputation, Professional'
```

Creates the signed JSON-LD:

```json
{
    "@context": "https://w3id.org/credentials/v1",
    "type": [
        "Reputation",
        "Professional",
        "Claim"
    ],
    "issuer": "did:00a65b11-593c-4a46-bf64-8b83f3ef698f",
    "issued": "2016-11-10T01:40:22-08:00",
    "claim": {
        "id": "did:59f269a0-0847-4f00-8c4c-26d84e6714c4",
        "summary": "Awesome paper!!!"
    },
    "signature": {
        "type": "sha256-ecdsa-secp256k1-2016",
        "created": "2016-11-10T09:40:22Z",
        "creator": "sha256-ecdsa-secp256k1-public-key:020d79074ef137d4f338c2e6bef2a49c618109eccf1cd01ccc3286634789baef4b",
        "domain": "example.com",
        "signatureValue": "H7P9Da4/JlqTUiJyYJPQIgAD4oWKDhjQ/J5wDC2ma75KPG07yWskDthLEJxcpFwu+xzTIAQa9O1I9dVOkCqsqEY="
    }
}
```

We canonicalize the JSON, by minifying and sorting hashes by keys:

```json
{"@context":"https://w3id.org/credentials/v1","claim":{"id":"did:59f269a0-0847-4f00-8c4c-26d84e6714c4","summary":"Awesome paper!!!"},"issued":"2016-11-10T01:40:22-08:00","issuer":"did:00a65b11-593c-4a46-bf64-8b83f3ef698f","signature":{"created":"2016-11-10T09:40:22Z","creator":"sha256-ecdsa-secp256k1-public-key:020d79074ef137d4f338c2e6bef2a49c618109eccf1cd01ccc3286634789baef4b","domain":"example.com","signatureValue":"H7P9Da4/JlqTUiJyYJPQIgAD4oWKDhjQ/J5wDC2ma75KPG07yWskDthLEJxcpFwu+xzTIAQa9O1I9dVOkCqsqEY=","type":"sha256-ecdsa-secp256k1-2016"},"type":["Reputation","Professional","Claim"]}
```

Then hash the canonical JSON to get an ID for the claim:

```
QmZSLsc5ndnr1YtwVw7fyEqotp5J6KaDYGRi3ty6tiiw1g  # sha2-256 multihash
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
and in July 2015 were together at [Citizen Code](http://www.citizencode.io/),
along with [Joel Dietz](http://fractastical.com/),
who had previously designed and written about systems for trust, including
"[green ether](https://github.com/fractastical/etherea/blob/master/green_ether.md)".

Harlan, Joel, and Noah decided to create an open source, permissively licensed,
reference implementation of Trust Exchange, as a foundation for free, open,
interoperable trust systems.  Their plan was enthusiastically supported by
Adam and Jack, and in August 2015 this version of Trust Exchange was born.
