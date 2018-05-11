'use strict'

const { PluginError } = require('gulp-util')
const prettierEslint = require('prettier-eslint')
const map = require('map-stream')

module.exports = () => {
  const report = { changed: 0, unchanged: 0 }
  return map(format).on('end', () => {
    if (report.changed > 0) {
      const changed = 'formatted '
        .concat(report.changed)
        .concat(' file')
        .concat(report.changed === 1 ? '' : 's')
      const unchanged = 'left '
        .concat(report.unchanged)
        .concat(' file')
        .concat(report.unchanged === 1 ? '' : 's')
        .concat(' unchanged')
      console.log(`prettier-eslint: ${changed}; ${unchanged}`)
    } else {
      console.log(`prettier-eslint: left ${report.unchanged} file${report.unchanged === 1 ? '' : 's'} unchanged`)
    }
  })

  function format (file, next) {
    if (file.isNull()) return next()
    if (file.isStream()) return next(new PluginError('gulp-prettier-eslint', 'Streaming not supported'))

    const input = file.contents.toString()
    const output = prettierEslint({ text: input })

    if (input === output) {
      report.unchanged += 1
    } else {
      report.changed += 1
      file.contents = Buffer.from(output)
    }

    next(null, file)
  }
}
