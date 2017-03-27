import {d, multihash, run} from 'lightsaber'
import fs from 'fs'
let jsonldSignatures = require('jsonld-signatures')
import bitcore from 'bitcore-lib'
import canonicalJson from 'json-stable-stringify'
import moment from 'moment'

export default class Trust {
  claim = (opts) => {
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
        keywords: opts.tags.split(/\s*,\s*/).join(', ').trim(),
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

    return jsonldSignatures.promises.sign(claim, {
      privateKeyWif: opts.privateKey,
      algorithm: 'EcdsaKoblitzSignature2016',
      domain: 'example.com',
      creator: 'EcdsaKoblitz-public-key:' + new bitcore.PrivateKey(opts.privateKey).toPublicKey()
    })
  }

  put = (atom, opts) => {
    if (opts.storage === 'holochain') {
      let params = merge(params, { atom })
      d(params)
      return axios.post(`http://localhost:3141/fn/trustClaim/claim`, params)
    } else {
      throw new Error('unknown opts.storage "' + opts.storage + '"')
    }
  }


  get = () => d('TODO: implement this')
  map = () => d('TODO: implement this')

}
