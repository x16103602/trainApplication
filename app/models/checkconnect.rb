require 'json'
require 'httparty'
class CheckConnect
    include HTTParty
    def self.getUrlInfo(name)
    url="https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets/"
    @responsed = HTTParty.get(url).parsed_response
    #print(@responsed)
    #responsebody = JSON.parse(response.body)
    return @responsed
    end


end
