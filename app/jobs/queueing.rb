require 'httparty'
require 'json'
class Queueing
  @queue = :kishorequeue

  def self.perform(queue)
    customer = Stripe::Customer.create(:email => queue[1], :source  => queue[2])
    charge = Stripe::Charge.create(:customer => customer.id, :amount => queue[0], :description => 'Rails Stripe customer', :currency => 'eur')
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to payment_path
  end
end