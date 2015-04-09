_ = require 'lodash'
R = require("require-root")("project")
Q = require "q"

config = R("config/dev")


# global vars
intervals = []
stationsByProvider = {}

# event handlers

###
Finishes any last tasks and exits
###
cleanup = ->
	for interval in intervals
		clearInterval interval

	# exit at the next best opportunity
	setTimeout process.exit, 1

process.on "SIGINT", cleanup
process.on "SIGTERM", cleanup


# Setup DB
initDatabase = ->
	# connect
	# load data

###
Creates process pool of several "DatabaseFiller"s

We will calculate how many processes we will start with
using the assumedActionTime, interval and itemCount

The generic-pool will take care of creating and destroying processes
depending on how many are left and how long they were idle.

@param assumedActionTime {Integer} Time we assume an action
						normally takes
@param interval {Integer} How long it should take to treat all items
@param itemCount {Integer} Number of items we will have to treat in the given interval
@return pool {Object}
###
getPool = (assumedActionTime, interval, itemCount)->



###
We will migrate the @see{DatabaseFiller::queueNextUpdate}
that will be called to dequeue a process, treat the update
and requeue until the next timeout
###
main = (refreshInterval, pool)->