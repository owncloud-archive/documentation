'use strict'

const connect = require('gulp-connect')
const chokidar = require('chokidar')

module.exports = (serveDir, opts) => {
  let watch
  if (opts) {
    opts = Object.assign({}, opts)
    watch = opts.watch
    delete opts.watch
  } else {
    opts = {}
  }

  let onStart
  if (watch && watch.src && watch.onChange) {
    onStart = () => {
      chokidar
        .watch(watch.src, { ignoreInitial: true })
        .on('add', watch.onChange)
        .on('change', watch.onChange)
        .on('unlink', watch.onChange)
    }
  }

  opts.root = serveDir
  connect.server(opts, onStart)
}
