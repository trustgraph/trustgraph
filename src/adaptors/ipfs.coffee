{ json, log, p, pjson } = require 'lightsaber'
Promise = require 'bluebird'
sphere = require 'nodesphere'
nodesphereIpfs = sphere.adaptor.Ipfs
canonicalJson = require 'json-stable-stringify'

class IpfsAdaptor
  @create: (args={}) ->
    nodesphereIpfs.create args
      .then (ipfs) ->
        return new IpfsAdaptor {ipfs}

  constructor: ({@ipfs}) ->
    unless @ipfs instanceof nodesphereIpfs
      throw new error "@ipfs is not instanceof ipfsAPI -- try calling .create(...) if you called the constructor directly"

  name: -> "InterPlanetary File System"

  putClaim: (trustAtom) ->
    { source, target, value, content } = trustAtom
    json = canonicalJson trustAtom
    @ipfs.put content: json
      .then (hashes) ->
        throw new Error if hashes.length isnt 1
        "Saved to IPFS: #{hashes[0]}"

  ratingsOf: (identity) -> Promise.resolve []  # currently we cannot query into IPFS objects...

module.exports = IpfsAdaptor
