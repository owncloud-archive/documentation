'use strict'

const vfs = require('vinyl-fs')
const stylelint = require('gulp-stylelint')

module.exports = (files) =>
  vfs.src(files).pipe(
    stylelint({
      reporters: [{ formatter: 'string', console: true }],
    })
  )
