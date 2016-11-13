const program = require('commander')

program
  .command('claim', 'Create trust claim')
  .command('get', 'Retrieve trust claims')
  .parse(process.argv)
