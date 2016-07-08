module.exports = (grunt)->
	index_app = ['helpers_app', 'landing_widgets_app','index_app']

	generateFilePattern = (dirs)->
		list=[]
		for d in dirs
			if '*' in d
				list.push('client/'+d)
				continue
			list.push('client/'+d+"/**/module*.js")
			list.push('client/'+d+"/**/!(module*)*.js")
		list



	grunt.initConfig {
		pkg: grunt.file.readJSON('package.json')
		replace:
			options:{},
			files:{
					expand: true,
					cwd: 'client',
					src: ['**/*.js', '**/*.html'],
					dest: 'client',
				}
		tags:
			build: {
				options: {
					scriptTemplate: '<script src="/{{ path }}"></script>',
					linkTemplate: '<link href="/{{ path }}"/>',
					absolutePath: true
				},
				src: generateFilePattern(index_app),
				dest: 'views/index.jade'
			}
		less_imports:
				options:{},
				client:{
					src: [ 'client/*_app/**/style.less'],
					dest: 'client/auto_imports.less'
				},
				landing_widgets:{
					src: (()->
						grunt.file.copy('client/quote.png', 'dist/quote.png')
						[
							'bower_components/bootstrap/less/bootstrap.less',
							'client/landing_widgets_app/**/style.less',
							'client/animations.less'
						]
						)()
					,
					dest: 'dist/auto_imports.less'
				}
		watch:
			js_html:{
					files: ['client/*_app/**/*.js', 'client/*_app/**/*.html' ],
					tasks: ['replace', 'tags']
			},
			css:{
					files: ['client/*_app/**/*.less', 'client/*.less' ],
					tasks: ['less_imports', 'less:prod']
			}
		coffee:
			glob_to_multiple: {
				expand: true,
				cwd: 'client',
				src: ['**/**/*.coffee'],
				dest: 'client',
				ext: '.js'
			}
		# pug == jade templates
		pug:
			views:{
				files: [{
					expand: true,
					cwd: 'views',
					src: ['**/**/*.jade'],
					dest: 'views',
					ext: '.html'
				}]
			},
			client:{
				files: [{
					expand: true,
					cwd: 'client',
					src: ['**/**/*.jade'],
					dest: 'client',
					ext: '.html'
				}]
			},
		concat:
			options:{
				separator:';\n'
			},
			index_app:{
				src: generateFilePattern(index_app)
				dest:'client/index_app.js'
			},
			landing_widgets_app:{
				src: generateFilePattern(['landing_widgets_app']),
				dest: 'client/landing_widgets_app.js'
			},
			landing_widgets_app_less:{
				options:{
					separator:''
				}
				src: ['client/landing_widgets_app/**/*.less'],
				dest: 'dist/style.less'
			},
		less:
			prod:{
				options:{
					#compress:true
				},
				files:{
					'client/style.css':'client/style.less'
					#'client/css/style-admin.css':'client/style-admin.less',
					#'client/css/style-moderator.css':'client/style-moderator.less'
				}
			}
			dist:{
				options:{
					compress:true
				},
				files:{
					'dist/style.css': ['dist/auto_imports.less']
				}
			}
		wiredep:
			task: {
				src: [
					'views/**/*.jade'
				],
				options: {
						cwd: './',
						ignorePath: '..',
						#ignorePath: '../bower_components',
						dependencies: true,
						devDependencies: false,
					}
			}
		nggettext_extract:
			pot: {
				files: {
					'po/template.pot': ['views/**/*.html', 'client/**/*.html']
				}
			},
		nggettext_compile:
			lazy: {
				options: {
					format: "json"
				},
				files: [
					{
						expand: true,
						dot: true,
						cwd: "po",
						dest: "client/languages",
						src: ['*.po'],
						ext: ".json"
					}
				]
			}
		uglify:
			dist:{
				files:{
					'dist/lw.min.js':['client/landing_widgets_app.js']
				}
			}
		angular_template_inline_js:
			options:{
				basePath: __dirname
			},
			files:{
				cwd: 'client',
				expand: true,
				src: ['*.js'],
				dest: 'client'
			}
	}
	grunt.loadNpmTasks 'grunt-script-link-tags'
	grunt.loadNpmTasks 'grunt-replace'
	grunt.loadNpmTasks 'grunt-wiredep'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-simple-watch'
	grunt.loadNpmTasks 'grunt-less-imports'
	grunt.loadNpmTasks 'grunt-contrib-pug'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-angular-template-inline-js'

	grunt.loadNpmTasks 'grunt-angular-gettext'
	grunt.registerTask 'po', [
			'pug:views',
			'pug:client',
			'nggettext_extract'
	]
	grunt.registerTask 'po-compile', 'nggettext_compile:lazy'


	grunt.registerTask 'default', 'simple-watch'
	grunt.registerTask 'index_app', [
			'less_imports',
			'less:prod',
			'replace',
			'concat:index_app'
	]
	grunt.registerTask 'dist', [
		'less_imports:landing_widgets',
		'less:dist',
		'replace',
		'concat:landing_widgets_app',
		'angular_template_inline_js',
		'uglify:dist',
		'concat:landing_widgets_app_less'
	]
