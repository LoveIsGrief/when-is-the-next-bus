###
providerData =
	providerName1:
		stationCode1({String}):
			stationData1({StationData})
	#.
	#.
	#.
	providerNameN:
		stationCodeN({String}):
			stationDataN({StationData})
###
class ProviderData

	constructor: ->

	###
	@param providerName {String}
	###
	addProvider: (providerName)->
		@[providerName] = @[providerName] || {}

	###
	@param providerName {String}
	@param stationData {StationData}
	###
	addStationData: (providerName, stationData)->
		@addProvider providerName
		@[providerName][stationData.code] = stationData

	toString: ->
		JSON.stringify @


module.exports = ProviderData