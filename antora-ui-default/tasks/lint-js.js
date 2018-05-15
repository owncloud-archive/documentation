'use strict'

const vfs = require('vinyl-fs')
const eslint = require('gulp-eslint')

module.exports = (files) =>
  vfs
    .src(files)
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failAfterError())
