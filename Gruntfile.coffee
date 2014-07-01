module.exports = (grunt) ->
  'use strict'

  require('load-grunt-tasks')(grunt)
  require('time-grunt')(grunt)

  config =
    app: 'app'
    build: 'build'
    dist: 'dist'

  grunt.initConfig
    config: config

    pkg: grunt.file.readJSON('package.json')

    coffee:
      dev:
        files: [
          expand: true
          cwd: 'js'
          src: ['**/*.coffee', '!**/_*.coffee']
          dest: '<%= config.build %>/js'
          ext: '.js'
        ]

    sass:
      options:
        loadPath: [
          'bower_components'
        ]
      dev:
        files: [
          expand: true
          cwd: 'css'
          src: ['**/*.sass', '!**/_*.sass']
          dest: '<%= config.build %>/css'
          ext: '.css'
        ]

    autoprefixer:
      options:
        browsers: ['last 1 version', '> 1%']
      dev:
        files: [
          expand: true
          cwd: 'build/css'
          src: '*.css'
          dest: 'build/css'
        ]

    compass:
      dist:
        options:
          sassDir: 'sass'
          cssDir: 'dist/css'
          environment: 'production'
      dev:
        options:
          sassDir: 'sass'
          cssDir: 'build/css'

    slim:
      options:
        pretty: true
      dev:
        files: [
          expand: true
          src: ['*.slim', '!_*.slim']
          dest: 'build'
          ext: '.html'
        ]

    compress:
      dev:
        options:
          archive: '/tmp/build.zip'
        files: [
          expand: true
          cwd: 'build'
          src: ['**']
          dest: 'build'
        ]
      dist:
        options:
          archive: '/tmp/dist.zip'
        files: [
          expand: true
          cwd: 'dist'
          src: ['**']
          dest: 'dist'
        ]

    clean:
      dev: 'build/*'
      dist: 'dist/*'

    connect:
      options:
        hostname: 'localhost'
        #hostname: '0.0.0.0'
        port: 9999
        livereload: true
        open: true
      livereload:
        options:
          base: '<%= config.build %>'
          middleware: (connect)->
            [
              connect.static(config.build)
              connect().use('/bower_components', connect.static('bower_components'))
              connect.static(config.app)
            ]
      dist:
        options:
          port: 9998
          base: '<%= config.dist %>'
          livereload: false

    copy:
      dist:
        files: [ {
          expand: true
          cwd: 'build'
          src: 'js/**/*.js'
          dest: '<%= config.dist %>'
        }, {
          expand: true
          cwd: 'build'
          src: 'css/**/*.css'
          dest: '<%= config.dist %>'
        } , {
          expand: true
          cwd: 'build'
          src: 'img/**/*'
          dest: '<%= config.dist %>'
        }, {
          expand: true
          cwd: 'build'
          src: 'fonts/**/*'
          dest: 'build'
        }, {
          expand: true
          cwd: 'build'
          src: '**/*.html'
          dest: '<%= config.dist %>'
        } ]
      dev:
        files: [ {
          expand: true
          src: 'js/**/*.js'
          dest: 'build'
        }, {
          expand: true
          src: 'css/**/*.css'
          dest: 'build'
        }, {
          expand: true
          src: 'img/**/*'
          dest: 'build'
        }, {
          expand: true
          src: 'fonts/**/*'
          dest: 'build'
        } ]

    sprite:
      dev:
        src: 'sprites/*.png'
        destImg: 'build/img/sprites.png'
        destCSS: 'build/css/sprites.css'
        algorithm: 'binary-tree'
        padding: 0
        cssOpts:
          cssClass: (item) -> ".sprite-#{item.name}"

    browserify:
      dev:
        options:
          transform: ['coffeeify', 'debowerify']
        files: {}

    bower: # grunt-bower-task, not used
      dev:
        options:
          targetDir: 'build'
          layout: 'byType'

    bowerInstall: # grunt-bower-install
      html:
        src: ['<%= config.build %>/index.html']

    concurrent:
      options:
        logConcurrentOutput: true
      assets:
        tasks: ['slim:dev']
      dev:
        tasks: ['watch']

    notify:
      watch:
        options:
          title: 'grunt'
          message: 'changed'

    useminPrepare:
      options:
        dest: '<%= config.dist %>',
      html: '<%= config.build %>/**/*.html'
      css: ['<%= config.dist %>/css/**/*.css']

    rev:
      dist:
        files:
          src: [
            '<%= config.dist %>/css/**/*.css'
            '<%= config.dist %>/js/**/*.js'
          ]

    usemin:
      options:
        assetsDirs: ['<%= config.dist %>']
      html: ['<%= config.dist %>/**/*.html'],
      css: ['<%= config.dist %>/css/**/*.css']

    htmlmin:
      dist:
        options:
          collapseBooleanAttributes: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeCommentsFromCDATA: true
          removeEmptyAttributes: true
          removeOptionalTags: true
          removeRedundantAttributes: true
          useShortDoctype: true
        files: [ {
          expand: true
          cwd: '<%= config.dist %>',
          src: '**/*.html'
          dest: '<%= config.dist %>'
        } ]

    watch:
      options:
        livereload: true
        spawn: false

      coffee:
        files: ['js/**/*.coffee']
        tasks: ['coffee:dev']

      sass:
        files: ['css/**/*.sass']
        tasks: ['sass:dev', 'autoprefixer:dev']

      slim:
        files: ['*.slim']
        tasks: ['slim:dev', 'bowerInstall']

  grunt.registerTask 'dev', ['copy:dev', 'coffee:dev', 'sass:dev', 'autoprefixer:dev', 'slim:dev', 'bowerInstall']
  grunt.registerTask 'dist', ['clean:dist', 'copy:dist', 'useminPrepare', 'concat', 'uglify', 'rev', 'usemin', 'htmlmin']
  grunt.registerTask 'default', ['dev', 'connect:livereload', 'watch']
