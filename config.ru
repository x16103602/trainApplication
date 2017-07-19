# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack'
require 'rack/cache'
require 'redis-rack-cache'


run Rails.application

use Rack::Cache,
metastore: "#{ENV["REDIS_URL"]}/1/metastore",
entitystore: "#{ENV["REDIS_URL"]}/1/entitystore"

$redis.set("myapiurl", "https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets")
$redis.set("api_cancel", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/cancelBookings")
$redis.set("api_index", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/bookings")
$redis.set("api_delete", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/deleteBooking")
$redis.set("api_show", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/getbooking")
$redis.set("api_book", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/booking")
$redis.set("api_register", "http://theaterbooking-env.eu-west-1.elasticbeanstalk.com/rest/service/register")
$redis.set("api_authorize", "Token token=\"HHHcSv22p8ta36kOrxHhIwtt\"")


        