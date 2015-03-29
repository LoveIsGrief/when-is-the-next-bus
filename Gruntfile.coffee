module.exports = (grunt)->


	grunt.initConfig
		coffee:
			options:
				bare: true
			devMultiple:
				expand: true
				cwd: "src"
				src: [ "**.coffee" ]
				dest: "build/"
				ext: ".js"
			devSingle:
				options:
					join: true
				src: [ "src/**.coffee" ]
				dest: "build/main.js"

		codo:
			src: [
				"src"
			]

		jasmine_nodejs:
			options:
				specNameSuffix: "spec.coffee"
				helperNameSuffix: "helper.js"
				useHelpers: true
				reporters:
					console:
						cleanStack: false
			specs:
				specs: [
					"specs/**"
				]
				helpers: [
					"specs/helpers"
				]



	grunt.registerTask "default", ["coffee"]
	grunt.registerTask "doc", ["codo"]
	grunt.registerTask "test", "jasmine_nodejs"

	grunt.loadNpmTasks "grunt-codo"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-jasmine-nodejs"