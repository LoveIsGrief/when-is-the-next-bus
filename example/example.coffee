###

This should link the bus stations to their providers
with the relevant data.
Add clickable stations to the map.

@param leafletMap a map from the leaflet API
###
updateWithBusStations = (leafletMap)->

onload = (event)->

	gpsData =  geolocalize()
	map.show(gpsData)

	updateWithBusStations(map)

###

@param event {Object}
	A DOM event object with additional fields:
		station: <@see Station>
		popupBox: <Leaflet::PopupBox>
###
onclick = (event)->

	station = event.station
	popupBox = event.popupBox

	for provider, stationData of station.providerData

		urlBuilder = null
		responseHandler = null
		switch provider
			when "Envibus"
				urlBuilder = new UrlBuilderForEnvibus
				responseHandler = new ResponseHandlerForEnvibus(popupBox)

			when "LigneAzur"
				urlBuilder = new UrlBuilderForLigneAzur
				responseHandler = new ResponseHandlerForLigneAzur(popupBox)

			xhr.send urlBuilder.buildUrlStationsNextBuses(stationData),
				responseHandler.success,
				responseHandler.error