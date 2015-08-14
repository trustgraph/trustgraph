TODO:

- rater signs this hash with their private key
- no objective trust scores, only computable within the context a particular trust network


- use cases
  - club card rating user
  - finding information via trust web
-  interface side
- value



DID: Distributed ID (hash of public key)
DID can be an individual or org
DID1 rates DID2

, public, private,


context: <context/type>    # 256 char max?




## Super Nodes & Super Edges

- Neo4J
- IPFS
- Ethereum?


NaCl -- 25519 keys [eris supports] -- 32 bytes approx eq to 5000 bytes (or bits?) RSA
- tweet nacl -- https://github.com/dchest/tweetnacl-js
- app: asignify on mac
- minilock



An example of a "3 star" rating as a Trust Atom:

```json
{
  "source": "multihash-QmWdprFxhCWzjJ6D9Tw9tj5FyWFauhYuGtDQigVvwfteNv",
  "target": "http://ipfs.io/",
  "content": "like",
  "raw_value": 3,
  "maximum": 5,
  "rating_type": "5-star",
  "timestamp": "2015-08-11T22:32:23.207Z"
}
```
