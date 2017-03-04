import {d} from 'lightsaber'
import config from 'commander'
import {concat} from 'lodash'

import Trust from '../core/Trust'

class Actions {
  constructor() {
    this.actions = {}
    this.actions.claim = [
      // TODO make some options required
      ['--creator <creator>',         'DID or URL of claim creator'],
      ['--target <target>',           'DID or URL of claim target'],
      ['--description <description>', 'Rating description'],
      ['--tags <tag1, tag2>',         'Rating tags'],
      ['--value <value>',             'Rating weight in the range 0..1'],  // TODO make it numeric && validate between 0..1
      ['--algorithm <algorithm>',     'Signing algorithm'],
      ['--private-key <key>',         'Private key']
    ]
    this.actions.get = [
      ['--perspective <DID>',       'Perspective (identity) through which trust network is seen'],
      ['--creator <creator>',       'DID or URL of claim creator'],
      ['--target <target>',         'DID or URI of claim target'],
      ['--tags <tag1, tag2>',       'Filter by tags'],
      ['--depth <levels>',          'Crawls trust ratings to specified depth'],
      ['--min-value <value>',       'Min trust rating 0..1'],
      ['--max-value <value>',       'Max trust rating 0..1']
    ]
    this.actions.map = concat(this.actions.get, [
      ['--summarize',               'Summarize claims / build analysis'],
      ['--falloff',                 'Trust level relative to depth, eg: [1, 0.5, 0.33]']
    ])
  }

  // list = (val) => {
  //   return val.split(/,\s*/)
  // }

  exec = (action) => {
    const options = this.actions[action]
    for (const optionArgs of options) {
      config.option(...optionArgs)
    }
    config.parse(process.argv)
    const trust = new Trust()
    const trustMethod = trust[action]
    trustMethod(config)
  }
}

module.exports = new Actions()
