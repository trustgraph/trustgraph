#!/usr/bin/env coffee

{log, p, pjson, sha256} = require 'lightsaber'
forge = require 'node-forge'

SECURE = 2048
FAST = 512
# BITS = SECURE
BITS = FAST

main = ->
  trustAtom = {"content": "cultural maven","source": "QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target": "http://twitter.com/alice","timestamp": "2015-08-11T22:32:23.207Z"}

  json = JSON.stringify trustAtom

  hash = sha256 json

  keypair = forge.pki.rsa.generateKeyPair bits: BITS, e: 0x10001
  {privateKey, publicKey} = keypair

  md = forge.md.sha1.create()
  md.update hash, 'utf8'
  signature = privateKey.sign md
  forge.util.bytesToHex signature

  # verify with real public key:
  verify md, signature, publicKey

  badActorKeyPair = forge.pki.rsa.generateKeyPair bits: BITS, e: 0x10001
  badActorPublicKey = badActorKeyPair.publicKey

  # attempt to verify with bad actor public key:
  verify md, signature, badActorPublicKey

verify = (md, signature, publicKey) ->
  try
    verified = publicKey.verify md.digest().bytes(), signature
    log "verification successful"
  catch
    log "verification failed"

main()
