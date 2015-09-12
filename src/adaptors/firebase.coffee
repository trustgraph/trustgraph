{ json, log, p, pjson, sha256 } = require 'lightsaber'
{ pick } = require 'lodash'
Promise = require 'bluebird'
Firebase = require 'firebase'
Fireproof = require 'fireproof'  # promises for firebase
Fireproof.bless Promise
canonicalJson = require 'json-stable-stringify'

class FirebaseAdaptor
  FULL_NAME: "Firebase"
  SHORT_NAME: FirebaseAdaptor::FULL_NAME

  constructor: ({connection}) ->
    @fireproof = if connection instanceof Fireproof
      connection
    else # if connection instanceof Firebase  # "the right thing to do", but fails :(
      new Fireproof connection

  putClaim: ({ source, target, value, content, hints }) ->
    trustAtom = pick { source, target, value, content }, (value, key) -> value? and key?
    json = canonicalJson trustAtom
    key = "sha256-#{sha256 json}"

    ref = if hints?.firebase?
      @fireproof.child "#{hints.firebase}/#{key}"
    else
      @fireproof.child key

    ref.set trustAtom
      .then =>
        "#{@SHORT_NAME}: #{hints.firebase}/#{key}"

  ratingsOf: (identity) -> Promise.resolve []  # TODO implement

module.exports = FirebaseAdaptor
