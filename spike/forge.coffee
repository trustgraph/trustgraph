forge = require 'node-forge'

console.log keypair = forge.pki.rsa.generateKeyPair({bits: 512, e: 0x10001})
privateKey = keypair.privateKey

md = forge.md.sha1.create()
md.update('{"description":"content addressable graph infrastructure","rating":0.99,"source":"multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv","target":"http://ipfs.io/"}', 'utf8')
console.log signature = forge.util.bytesToHex privateKey.sign(md)
