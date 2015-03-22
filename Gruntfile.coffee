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



	grunt.registerTask "default", ["coffee"]
	grunt.registerTask "doc", ["codo"]

	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-codo"