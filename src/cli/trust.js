const program = require('commander')

program
  .command('claim', 'Create trust claim')
  .command('get', 'Retrieve trust claims')
  .command('map', 'Retrieve and analyze trust claims')
  .parse(process.argv)
