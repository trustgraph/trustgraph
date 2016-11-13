import {d, multihash, run} from 'lightsaber'
import fs from 'fs'
const jsonldSignatures = require('jsonld-signatures')
import bitcore from 'bitcore-lib'
import canonicalJson from 'json-stable-stringify'
import moment from 'moment'

export default class Trust {
  claim = (opts) => {
    opts.tags = opts.tags || []
    opts.tags.push('Claim')

    const claim = {
      '@context': 'https://w3id.org/credentials/v1',
      type: opts.tags,
      issuer: opts.creator,
      issued: moment().format(),
      claim: {
        id: opts.target,
        summary: opts.claimSummary
      }
    }

    d('\ninput:')
    d(JSON.stringify(claim, null, 4))

    let result
    jsonldSignatures.promises.sign(claim, {
      privateKeyWif: opts.privateKey,
      algorithm: 'sha256-ecdsa-secp256k1-2016',
      domain: 'example.com',
      creator: 'sha256-ecdsa-secp256k1-public-key:' + new bitcore.PrivateKey(opts.privateKey).toPublicKey()
    }).then(function (_result) {
      result = _result
      d('\n\nsigned json:')
      d(result)
      const json = canonicalJson(result)
      d('\n\ncanonical json to timestamp:')
      d(json)
      d('\n\nmultihash:')
      d(multihash(json))
      run('mkdir -p claims')
      fs.writeFileSync('claims/xyz', canonicalJson(result))
      const id = run('ipfs add -q claims/xyz').toString().trim()
      d('open https://ipfs.io/ipfs/' + id)
      return
    }).catch(function (error) {
      console.error(error.stack)
      process.exit(1)
    })
  }

  get = () => d('TODO: implement this')

}
