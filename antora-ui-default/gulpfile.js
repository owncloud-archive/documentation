'use strict'

const connect = require('gulp-connect')
const path = require('path')
const gulp = require('gulp')

const build = require('./tasks/build')
const buildPreview = require('./tasks/build-preview')
const format = require('./tasks/format')
const lintCss = require('./tasks/lint-css')
const lintJs = require('./tasks/lint-js')
const pack = require('./tasks/pack')
const preview = require('./tasks/preview')

const bundleName = 'ui'
const buildDir = 'build'
const previewSiteSrcDir = 'preview-site-src'
const previewSiteDestDir = 'public'
const srcDir = 'src'
const destDir = path.join(previewSiteDestDir, '_')

const jsFiles = ['gulpfile.js', 'tasks/**/*.js', path.join(srcDir, '{helpers,js}/**/*.js')]

gulp.task('lint:css', () => lintCss(`${srcDir}/css/**/*.css`))
gulp.task('lint:js', () => lintJs(jsFiles))
gulp.task('lint', ['lint:css', 'lint:js'])

gulp.task('format', () => format(jsFiles))

gulp.task('build', () => build(srcDir, destDir))

gulp.task('build:preview', ['build'], () =>
  buildPreview(srcDir, destDir, previewSiteSrcDir, previewSiteDestDir, connect.reload)
)

gulp.task('preview', ['build:preview'], () =>
  preview(previewSiteDestDir, {
    port: 5252,
    livereload: process.env.LIVERELOAD === 'true',
    watch: {
      src: [srcDir, previewSiteSrcDir],
      onChange: () => gulp.start('build:preview'),
    },
  })
)

gulp.task('pack', ['build', 'lint'], () => pack(destDir, buildDir, bundleName))

gulp.task('default', ['build'])
