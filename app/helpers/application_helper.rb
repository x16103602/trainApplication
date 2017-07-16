module ApplicationHelper
    def myinitial
        $redis.set("myapiurl", "https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets")
        $redis.set("api_cancel", "http://87.44.4.210:8080/api/rest/service/cancelBookings")
        $redis.set("api_index", "http://87.44.4.210:8080/api/rest/service/bookings")
        $redis.set("api_delete", "http://87.44.4.210:8080/api/rest/service/deleteBooking")
        $redis.set("api_show", "http://87.44.4.210:8080/api/rest/service/getbooking")
        $redis.set("api_book", "http://87.44.4.210:8080/api/rest/service/booking")
        $redis.set("api_register", "http://87.44.4.210:8080/api/rest/service/register/")
    end
end
