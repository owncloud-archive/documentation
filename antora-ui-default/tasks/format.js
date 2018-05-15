'use strict'

const vfs = require('vinyl-fs')
const prettier = require('./lib/gulp-prettier-eslint')

module.exports = (files) =>
  vfs
    .src(files)
    .pipe(prettier())
    .pipe(vfs.dest((file) => file.base))
