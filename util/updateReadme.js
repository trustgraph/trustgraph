#!/usr/bin/env node

import {d, run} from 'lightsaber'
import fs from 'fs'
import path from 'path'

const PROJECT_ROOT = path.resolve(__dirname, '..')

const main = () => {
  const readmePath = path.join(PROJECT_ROOT, 'README.md')
  let content = fs.readFileSync(readmePath, 'UTF-8')
  content = content.replace(/```\s*(trust \w+ --help)(.|\n)+?```/g, commandOutput)
  fs.writeFileSync(readmePath, content)
}

const commandOutput = (_, command) => {
  let response = run(`${PROJECT_ROOT}/bin/${command}`, {quiet: true}).toString()
  // response = response.replace(/^\s*-h, --help.+?\n/, '')  // TODO fix, why not work?
  return '```\n' + command + '\n\n' + response.trim() + '\n```'
}

main()
