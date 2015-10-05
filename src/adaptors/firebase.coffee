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

  putClaim: ({ source, target, value, content }, options={}) ->
    trustAtom = pick { source, target, value, content }, (value, key) -> value? and key?

    # hash should only include source & target. otherwise, duplicates are created when user update rating.
    # json = canonicalJson trustAtom
    # atomId = "sha256-#{sha256 json}"
    atomId = sha256(canonicalJson({ source, target }))

    key = if options?.firebase?.path?
            "#{options.firebase.path}/#{atomId}"
          else
            atomId

    ref = @fireproof.child key
    ref.set(trustAtom).then =>
      "#{@SHORT_NAME}: #{key}"

  ratingsOf: (entity, options={}) ->
    @fireproof.child "#{options.firebase.path}/#{entity}/ratings"
      .on 'value'
      .then (snapshot) =>
        ratings = for hash, data of snapshot.val()
          source: data.source
          target: data.target
          value:  data.value
          content: data.content

module.exports = FirebaseAdaptor
