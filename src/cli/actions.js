import {d} from 'lightsaber'
import config from 'commander'

import Trust from '../core/Trust'

class Actions {
  constructor () {
    this.actions = {
      claim: [
        ['--creator <creator>',       'DID or URL of claim creator'],
        ['--target <target>',         'DID or URI of claim target'],
        ['--algorithm <algorithm>',   'Signing algorithm'],
        ['--private-key <key>',       'Bitcoin private key'],
        ['--claim-summary <summary>', 'Summary of claim type'],
        ['--tags <tag1,tag2>',        'Add tags / labels', this.list]
      ]
    }
  }

  list = (val) => {
    return val.split(/,\s*/)
  }

  exec = (action) => {
    const options = this.actions[action]
    for (const optionArgs of options) {
      config.option(...optionArgs)
    }
    config.parse(process.argv)
    const trust = new Trust()
    trust[action](config)
  }
}

module.exports = new Actions()
