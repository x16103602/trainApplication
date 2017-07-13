require 'checkconnect'
require 'httparty'
require 'json'
class HomeController < ApplicationController
  include HTTParty
before_action :check, except: [:index]

  def index
    if current_user
    redirect_to home_url
    end
  end
  
  def navigator
    @x = "welcome to train app"
    if current_user
    @d = current_user.name
    end
  end
  
  def ticketcheck
  end
  
  def ticketcheckerresult
    @checker = (HTTParty.get("https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets", :query => {:identify=>params[:customer_id]}, headers: {"Authorization" => "Token token=\"VfboRuOu7GuE0yz5lofIaAtt\""}).parsed_response).paginate(:page => params[:page], :per_page => 5)
  end
  
  
  def bookticket
  end
  
  def payment
    @ticketdetails = Array.new(13){Array.new(2)}
    @ticketdetails[0][0] = "Passenger Name"
    @ticketdetails[1][0] = "Age"
    @ticketdetails[2][0] = "Child ticket"
    @ticketdetails[3][0] = "Adult ticket"
    @ticketdetails[4][0] = "Travel From"
    @ticketdetails[5][0] = "Travel To"
    @ticketdetails[6][0] = "Travel Class"
    @ticketdetails[7][0] = "Valid Until Hour"
    @ticketdetails[8][0] = "Valid Until Date"
    @ticketdetails[9][0] = "Return Ticket"
    @ticketdetails[10][0] = "Unique Proof"
    @ticketdetails[11][0] = "Total Price"
    @ticketdetails[12][0] = "Ticket Generated Date"
    
    @ticketdetails[0][1] = params[:name]
    @ticketdetails[1][1] = params[:age]
    @ticketdetails[2][1] = params[:cticket]
    @ticketdetails[3][1] = params[:aticket]
    @ticketdetails[12][1] = Time.zone.now
    a=(params[:cticket]).to_i
    b=(params[:aticket]).to_i
    
    if params[:treturn].to_s.length > 0 then
      if(Time.zone.now+14.hour > Time.now.midnight+1.day)
        validitydate=Date.today+1.day
      else
        validitydate=Date.today
      end
      returnbool = "With Return"
      if params[:tclass] == 'firstc' then
        cost=2*2*(a*3+b*5)
      else
        cost=2*(a*3+b*5)
      end
      validityhour=(Time.zone.now+14.hour).strftime("%H:%M")
    else
      if(Time.zone.now+8.hour > Time.now.midnight+1.day)
        validitydate=Date.today+1.day
      else
        validitydate=Date.today
      end
      returnbool = "Without Return"
      if params[:tclass] == 'firstc' then
        cost=2*(a*3+b*5)
      else
        cost=a*3+b*5
      end
      validityhour=(Time.zone.now+14.hour).strftime("%H:%M")
    end
    @ticketdetails[8][1] = validitydate
    @ticketdetails[7][1] = validityhour
    @ticketdetails[4][1] = params[:tfrom]
    @ticketdetails[5][1] = params[:tto]
    @username = User.find(current_user.id)
    @ticketdetails[10][1] = @username.userid
    @ticketdetails[11][1] = cost
    @ticketdetails[9][1] = returnbool
    @ticketdetails[6][1] = params[:tclass]
    
    
    @ticketinfo = Ticket.new()
    @ticketinfo.name = params[:name]
    @ticketinfo.age = params[:age]
    @ticketinfo.cticket = params[:cticket]
    @ticketinfo.aticket = params[:aticket]
    @ticketinfo.tvdate = validitydate
    @ticketinfo.tvhour = validityhour
    @ticketinfo.tfrom = params[:tfrom]
    @ticketinfo.tto = params[:tto]
    @ticketinfo.proof = @username.userid
    @ticketinfo.price = cost
    @ticketinfo.treturn = returnbool
    @ticketinfo.tclass = params[:tclass]
    @ticketinfo.user_id = @username.id
    @ticketinfo.save
    
    return @ticketdetails
  end
  
  def stripecash
    @username = User.find(current_user.id)
    @tickettopost = Ticket.where(user_id: current_user.id).order('id desc').take(1)
    print(@ticketdetails)
    print(@username)
    
    @amount = (@tickettopost[0].price)*100
    customer = Stripe::Customer.create(:email => params[:stripeEmail], :source  => params[:stripeToken])
    charge = Stripe::Charge.create(:customer => customer.id, :amount => @amount, :description => 'Rails Stripe customer', :currency => 'eur')
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to payment_path
    
    #redirect_to ticketconfirmation_path
  end
  
  def ticketconfirmation
    @username = User.find(current_user.id)
    @tickettopost = Ticket.where(user_id: current_user.id).order('id desc').take(1)
    print("Result of Ticket to be posted and username")
    print(@tickettopost)
    print(@username)
    
    @resultofticket = HTTParty.post("https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets.json", :body => { :bookticket => {:name => @tickettopost[0].name, :age => @tickettopost[0].age, :aticket => @tickettopost[0].aticket, :cticket => @tickettopost[0].cticket, :tdate => @tickettopost[0].tvdate, :hour => @tickettopost[0].tvhour, :from => @tickettopost[0].tfrom, :to => @tickettopost[0].tto, :proof => @tickettopost[0].proof, :cost => @tickettopost[0].price, :tclass => @tickettopost[0].tclass, :treturn => @tickettopost[0].treturn}}.to_json, :headers => {"Authorization" => "Token token=\"HHHcSv22p8ta36kOrxHhIwtt\"", "Content-Type" => "application/json" })
    @checking = @resultofticket.response
    print("Result of Post :")
    print(JSON.parse(@resultofticket.body))
    print(@checking)
    
    if(@resultofticket.code == 201 || @resultofticket.code == 200)
      @myticketsapibooked = JSON.parse(@resultofticket.body)
    else
      @myticketsapibooked = "Ticket Booking is unsuccessful. Please contact support team"
    end
    #@myticketsapibooked = (HTTParty.get("https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets", :query => {:identify=>@username.userid}, headers: {"Authorization" => "Token token=\"HHHcSv22p8ta36kOrxHhIwtt\""}).parsed_response).paginate(:page => params[:page], :per_page => 5)
    
    #@gone = HTTParty.get("https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets/", :query => {:identify=>@username.userid}, headers: {"Authorization" => "Token token=\"HHHcSv22p8ta36kOrxHhIwtt\""}).parsed_response
    #@myticketdisplay = @gone.last
    #print("last ticket")
    #print(@myticketdisplay)
  end
  
  def tickethistory
    @username = User.find(current_user.id)
    @myticketsapihistoryres = (HTTParty.get("https://guarded-reaches-19746.herokuapp.com/api/v1/booktickets", :query => {:identify=>@username.userid}, headers: {"Authorization" => "Token token=\"HHHcSv22p8ta36kOrxHhIwtt\""}).parsed_response)
    @myticketsapihistory = (@myticketsapihistoryres.reverse).paginate(:page => params[:page], :per_page => 5)
    print(@myticketsapihistory)
  end
end
