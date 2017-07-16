require 'httparty'
require 'json'
class Queueing
  @queue = :kishorequeue

  def self.perform(params)
    JSON.load(params)
  end
end