###
providerData =
	providerName1:
		stationDataForProvider1:
	#.
	#.
	#.
	providerNameN:
		stationDataForProviderN:
###
class ProviderData

	constructor: ->
		@internalObject = {}

	###
	@param providerName {String}
	@param stationData {@see StationData}
	###
	addProvider: (providerName, stationData)->
		@internalObject[providerName] = stationData