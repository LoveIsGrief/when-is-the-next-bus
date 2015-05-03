###
{
	name: {String}
	buses: [
		{Busline}1
		...
		{Busline}N
	]
	nextBuses: [
		{ApproachingBusline}1
		...
		{ApproachingBusline}N
	]
}
###
class StationData

	###
	@param name {String}
	@param code {String}
	@param buses [Array<Busline>]
	###
	constructor: (
		@name=""
		@code=""
		@buses=[]
		)->

module.exports = StationData