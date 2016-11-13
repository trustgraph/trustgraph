const unusedVars = [
  'd'
]

const config = {
  extends: [
    'standard'
  ],
  parser: 'babel-eslint',
  plugins: [
    'promise'
  ],
  rules: {
    'linebreak-style': [2, 'unix'],
    'no-multi-spaces': 0,
    'no-nested-ternary': 2,
    'no-unused-vars': [2, { 'varsIgnorePattern': '^(' + unusedVars.join('|') + ')$' }],
    'no-var': 2,
    'promise/always-return': 2,
    'promise/catch-or-return': 1,
    'promise/no-native': 2
  }
}

module.exports = config
