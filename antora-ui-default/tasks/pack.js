'use strict'

const vfs = require('vinyl-fs')
const zip = require('gulp-vinyl-zip')

module.exports = async (src, dest, bundleName) =>
  vfs
    .src('**/*', { base: src, cwd: src })
    .pipe(zip.zip(`${bundleName}-bundle.zip`))
    .pipe(vfs.dest(dest))
