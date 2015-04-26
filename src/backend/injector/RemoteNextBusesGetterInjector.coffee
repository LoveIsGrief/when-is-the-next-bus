logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")

class RemoteNextBusesGetterInjector

	inject:(providername)->
		logger.debug "Getting RemoteNextBusesGetter for #{providername}"
		switch providername
				when "envibus"
					getter = new EnvibusRemoteNextBusesGetter
					getNextBusesForStation: getter.get.bind getter
				else
					getNextBusesForStation: (args...)->
						Q.fcall ->
							[]

module.exports = RemoteNextBusesGetterInjector