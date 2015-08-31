#!/usr/bin/env coffee

SECURE = 2048
FAST = 512
# KEY_LENGTH = SECURE
KEY_LENGTH = FAST

{log, p, pjson, sha256} = require 'lightsaber'
canonicalJson = require 'json-stable-stringify'
forge = require 'node-forge'
generateKeyPair = forge.pki.rsa.generateKeyPair

main = ->
  trustAtom =
    "source": "QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv"
    "target": "http://twitter.com/alice"
    "content": "cultural maven"
    "timestamp": "2015-08-11T22:32:23.207Z"

  json = canonicalJson trustAtom # Canonical JSON, minified and sorted by keys:
  # => {"content":"cultural maven","source":"QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target":"http://twitter.com/alice","timestamp":"2015-08-11T22:32:23.207Z"}

  hashOfJson = sha256 json
  # => d646939062061e0971df7a4c9136c5e80d2e4a2b3d9631210923f8400b6bbd69

  {privateKey, publicKey} = generateKeyPair bits: KEY_LENGTH
  messageDigest = forge.md.sha256.create()
  messageDigest.update hashOfJson, 'utf8'
  signature = privateKey.sign messageDigest

  # Verify with real public key:
  verify messageDigest, signature, publicKey
  # => Verification successful

  badActorKeyPair = generateKeyPair bits: KEY_LENGTH
  badActorPublicKey = badActorKeyPair.publicKey

  # Attempt to verify with bad actor public key:
  verify messageDigest, signature, badActorPublicKey
  # => Verification failed

verify = (messageDigest, signature, publicKey) ->
  try
    verified = publicKey.verify messageDigest.digest().bytes(), signature
    log "Verification successful"
  catch e
    if e.message.match /Encryption block is invalid/
      log "Verification failed"
    else
      throw e

main()
