import {d} from 'lightsaber'
import config from 'commander'

import Trust from '../core/Trust'

class Actions {
  constructor () {
    this.actions = {
      claim: [
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
