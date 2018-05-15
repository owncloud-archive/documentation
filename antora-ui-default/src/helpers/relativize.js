'use strict'

const { posix: path } = require('path')

// TODO memoize
module.exports = (from, to) => {
  if (!from || to.charAt() === '#') return to
  let hash = ''
  const hashIdx = to.indexOf('#')
  if (~hashIdx) {
    hash = to.substr(hashIdx)
    to = to.substr(0, hashIdx)
  }
  if (from === to) {
    return hash || (isDir(to) ? './' : path.basename(to))
  } else {
    return path.relative(path.dirname(from + '.'), to) + (isDir(to) ? '/' + hash : hash)
  }
}

function isDir (str) {
  return str.charAt(str.length - 1) === '/'
}
