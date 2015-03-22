class UrlBuilder

	###
	It should build a URL from the station data
	to send to a third party in order to get a list of buses
	that will pass at the stop in the near future.

	@param stationData {@see StationData}
		Provider specific station data to build URL from

	@returns a URL to call external / third-party services
	###
	buildUrlStationsNextBuses: (stationData)->
		throw "Not implemented"

module.exports = UrlBuilder