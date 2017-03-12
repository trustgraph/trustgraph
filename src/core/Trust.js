import {d, multihash, run} from 'lightsaber'
import fs from 'fs'
const jsonldSignatures = require('jsonld-signatures')
import bitcore from 'bitcore-lib'
import canonicalJson from 'json-stable-stringify'
import moment from 'moment'
import {merge} from 'lodash'
import axios from 'axios'
import Promise from 'bluebird'

export default class Trust {
  claim = (opts) => {
    opts.tags = (opts.tags || '').trim().split(/\s*,\s*/)
    opts.value = opts.value ? Number(opts.value) : null

    const claim = {
      '@context': 'https://schema.trust.exchange/TrustClaim.jsonld',
      // id: multihash of json of final signed claim??? add at end.
      type: 'TrustClaim',
      issuer: opts.creator,
      issued: moment().format(),
      claim: {
        '@context': 'https://schema.org/',
        type: 'Review',
        itemReviewed: opts.target,
        author: opts.creator,
        keywords: opts.tags.join(', '),
        reviewRating: {
          '@context': 'https://schema.org/',
          type: 'Rating',
          bestRating: 1,
          worstRating: 0,
          ratingValue: opts.value,
          description: opts.description
        }
      }
    }

    d('\ninput:')
    d(JSON.stringify(claim, null, 4))

    // let result
    // jsonldSignatures.promises.sign(claim, {
    //   privateKeyWif: opts.privateKey,
    //   algorithm: 'EcdsaKoblitzSignature2016',
    //   domain: 'example.com',
    //   creator: 'EcdsaKoblitz-public-key:' + new bitcore.PrivateKey(opts.privateKey).toPublicKey()
    // }).then((_result) => {
    //   result = _result
    //   d('\n\nsigned json:')
    //   d(result)
    //   const json = canonicalJson(result)
    //   d('\n\ncanonical json to timestamp:')
    //   d(json)
    //   d('\n\nmultihash:')
    //   d(multihash(json))
    //   run('mkdir -p claims')
    //   fs.writeFileSync('claims/xyz', json)
    //   const id = run('ipfs add -q claims/xyz').toString().trim()
    //   d('open https://ipfs.io/ipfs/' + id)

    const result = JSON.parse('{"@context":"https://schema.trust.exchange/TrustClaim.jsonld","claim":{"@context":"https://schema.org/","author":"did:00a65b11-593c-4a46-bf64-8b83f3ef698f","itemReviewed":"did:59f269a0-0847-4f00-8c4c-26d84e6714c4","keywords":"programming, Elixir","reviewRating":{"@context":"https://schema.org/","bestRating":1,"description":"Elixir programming","ratingValue":"0.99","type":"Rating","worstRating":0},"type":"Review"},"issued":"2017-03-04T02:05:07-08:00","issuer":"did:00a65b11-593c-4a46-bf64-8b83f3ef698f","signature":{"http://purl.org/dc/terms/created":{"@value":"2017-03-04T10:05:07Z","type":"http://www.w3.org/2001/XMLSchema#dateTime"},"http://purl.org/dc/terms/creator":{"id":"EcdsaKoblitz-public-key:020d79074ef137d4f338c2e6bef2a49c618109eccf1cd01ccc3286634789baef4b"},"sec:domain":"example.com","signature:Value":"IEd/NpCGX7cRe4wc1xh3o4X/y37pY4tOdt8WbYnaGw/Gbr2Oz7GqtkbYE8dxfxjFFYCrISPJGbBNFyaiVBAb6bs=","type":"sec:EcdsaKoblitzSignature2016"},"type":"TrustClaim"}')
    Promise.try(() => {

      return this.holochainCommit(result, opts)
    }).catch((error) => {
      console.error(error.stack)
      process.exit(1)
    })
  }

  holochainCommit = (result, opts) => {
    const params = merge(opts, {atom: result})
    return axios.post(`http://localhost:3141/fn/teh_js/claim`, params)
  }

  get = (opts) => {
    d('get:', opts)
    axios.post(`http://localhost:3141/fn/teh_js/get`, opts)
    .then((result) => {
      d("result:", result.data)
    })
    .catch((error) => {
      d("error:", error)
    })
  }

  map = () => d('TODO: implement this')

}
