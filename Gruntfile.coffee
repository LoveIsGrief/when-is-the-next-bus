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


	grunt.registerTask "default", ["coffee"]

	grunt.loadNpmTasks "grunt-contrib-coffee"