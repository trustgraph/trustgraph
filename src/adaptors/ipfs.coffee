{ json, log, p, pjson } = require 'lightsaber'
Promise = require 'bluebird'
canonicalJson = require 'json-stable-stringify'
ipfsApi = require 'ipfs-api'

class IpfsAdaptor
  FULL_NAME: "InterPlanetary File System"
  SHORT_NAME: "IPFS"

  @create: (args = {}) ->
    {host, port} = args
    host ?= process?.env?.IPFS_HOST
    port ?= process?.env?.IPFS_PORT
    if !window? and !host?
      return Promise.reject "host must be defined when running outside of a browser"
    ipfs = Promise.promisifyAll ipfsApi host, port
    ipfs.commandsAsync()
      .then => return new IpfsAdaptor {ipfs}

  constructor: ({@ipfs}) ->
    unless @ipfs instanceof ipfsApi
      throw new error "@ipfs is not instanceof ipfsAPI -- try calling
        .create(...) if you called the constructor directly"

  putClaim: (trustAtom) ->
    { source, target, value, content } = trustAtom
    json = canonicalJson trustAtom
    @put content: json
      .then (hashes) =>
        if not hashes?
          throw new Error "No hash returned for: #{json}"
        if hashes.length isnt 1
          throw new Error "Unexpected hashes.length: #{hashes.length}"
        "#{@SHORT_NAME}: #{hashes[0]}"

  put: ({content}) ->
    @ipfs.addAsync new @ipfs.Buffer content
      .then (items) =>
        for item in items
          item.Hash
      .catch (err) ->
        console.error err

  ratingsOf: (identity) -> Promise.resolve []  # currently we cannot query into IPFS objects...

module.exports = IpfsAdaptor
