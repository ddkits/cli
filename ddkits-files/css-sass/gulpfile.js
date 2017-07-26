'use strict';

var browserSync = require('browser-sync').create();
var gulp = require('gulp');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var autoprefixer = require('gulp-autoprefixer');
var notify = require('gulp-notify');
var plumber = require('gulp-plumber');


/**
 * Global vars
 */

var devEnv = 'dc.ddkits-ddkitsinc.dev';


/**
 * Error function which wont break gulp
 */

function errorAlert(error) {
  notify.onError({
    title: "SCSS Error",
    message: "😭  DDKits | Check your terminal to see what's wrong in your sass files 😭"
  })(error);
  console.log(error.toString());
  this.emit("end");
};


/**
 * gulp sass
 */

gulp.task('sass', function() {
  var stream = gulp.src('./sass/**/*.scss')
    .pipe(plumber({
      errorHandler: errorAlert
    }))
    .pipe(sourcemaps.init())
    .pipe(sass({
      errLogToConsole: true,
      outputStyle: 'nested' // nested | compact | expanded | compressed
    }))
    .pipe(autoprefixer('last 2 version'))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest('css'))
    .pipe(browserSync.stream())
    .pipe(notify({
      message: '🍺   DDKits | happy to tell you gulp is Done! 🍺',
      onLast: true
    }));
  return stream;
});


/**
 * gulp serve
 *
 * Use 'gulp serve' for working with browsersync
 * For a livereload workflow use 'gulp watch'
 */

gulp.task('serve', ['sass'], function() {
  browserSync.init({
    proxy: devEnv,
    open: false
  });
  gulp.watch('sass/**/*.scss', ['sass']);
  gulp.watch('js/*.js').on('change', browserSync.reload);

  // Gulp watch templates needs a Drupal cache rebuild before working
  gulp.watch('templates/*').on('change', browserSync.reload);
});


/**
 * gulp watch
 *
 * Use 'gulp watch' for working with livereload
 * For a browsersync workflow use 'gulp serve'
 */

gulp.task('watch', ['sass'], function() {
  livereload.listen();
  gulp.watch('sass/**/*.scss', ['sass']);
  gulp.watch('css/*.css').on('change', livereload.changed)
  gulp.watch('js/*.js', ['scripts']).on('change', livereload.changed)
  gulp.watch('templates/*').on('change', livereload.changed)
});


/**
 * gulp deploy
 */

gulp.task('deploy', ['sass'], function() {});


/**
 * Default gulp task calling 'gulp serve'
 */

gulp.task('default', ['serve'], function() {});
