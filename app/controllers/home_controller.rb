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
  
  def admin
    if Rails.env == 'production'
      @resqueurl = "https://chennaimetro.herokuapp.com/resque"
    else
      @resqueurl = "http://apiapp-spkishore007.c9users.io:8080/resque"
    end
  end
  def navigator
    @x = "welcome to train app"
    @username = User.find(current_user.id)
    
    if current_user
    @d = current_user.name
    end
    @myticketsapihistoryres = (HTTParty.get($redis.get("myapiurl"), :query => {:identify=>@username.userid}, headers: {"Authorization" => $redis.get("api_authorize")}).parsed_response)
    $redis.set("myticketshistroy", (@myticketsapihistoryres.reverse))
  end
  
  def ticketcheck
  end
  
  def ticketcheckerresult
    if(params[:customer_id])
      @checker = (HTTParty.get($redis.get("myapiurl"), :query => {:identify=>params[:customer_id]}, headers: {"Authorization" => $redis.get("api_authorize")}).parsed_response).paginate(:page => params[:page], :per_page => 5)
    end
    if(params[:customer_name])
      @checker = (HTTParty.get($redis.get("myapiurl"), :query => {:custname=>params[:customer_name]}, headers: {"Authorization" => $redis.get("api_authorize")}).parsed_response).paginate(:page => params[:page], :per_page => 5)
    end
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
    @queue = []
    print(@ticketdetails)
    print(@username)
    
    @amount = (@tickettopost[0].price)*100
    @queue[0] = (@tickettopost[0].price)*100
    @queue[1] = params[:stripeEmail]
    @queue[2] = params[:stripeToken]
    Resque.enqueue(Queueing, @queue)
  end
  
  def ticketconfirmation
    @username = User.find(current_user.id)
    @tickettopost = Ticket.where(user_id: current_user.id).order('id desc').take(1)
    
    @resultofticket = HTTParty.post($redis.get("myapiurl"), :body => { :bookticket => {:name => @tickettopost[0].name, :age => @tickettopost[0].age, :aticket => @tickettopost[0].aticket, :cticket => @tickettopost[0].cticket, :tdate => @tickettopost[0].tvdate, :hour => @tickettopost[0].tvhour, :from => @tickettopost[0].tfrom, :to => @tickettopost[0].tto, :proof => @tickettopost[0].proof, :cost => @tickettopost[0].price, :tclass => @tickettopost[0].tclass, :treturn => @tickettopost[0].treturn}}.to_json, :headers => {"Authorization" => $redis.get("api_authorize"), "Content-Type" => "application/json" })
    
    if(@resultofticket.code == 201 || @resultofticket.code == 200)
      @myticketsapibooked = JSON.parse(@resultofticket.body)
    else
      @myticketsapibooked = "Ticket Booking is unsuccessful. Please contact support team"
    end
    
    $redis.set("myticketdownload", @myticketsapibooked)
    
    @myticketsapihistoryres = (HTTParty.get($redis.get("myapiurl"), :query => {:identify=>@username.userid}, headers: {"Authorization" => $redis.get("api_authorize")}).parsed_response)
    $redis.set("myticketshistroy", (@myticketsapihistoryres.reverse).to_json)
  end
  
  def pdfticket
    # Using URI and Net:HTTP which are already included with Rails

    pdf = WickedPdf.new.pdf_from_string(render_to_string('home/ticketconfirmation.html.erb', layout: false))
    send_data pdf, :filename => "resume.pdf", :type => "application/pd", :disposition => "attachment"
    
    #pdf = render_to_string :pdf => $redis.get("myticketdownload"), :template => "home/ticketconfirmation.html.erb", :encoding => "UTF-8" # here show is a show.pdf.erb inside view
    #send_data pdf
    
    #respond_to do |format|
     # format.html
      #format.pdf do
       # @pdf = render_to_string :pdf => $redis.get("myticketdownload")
        #    #:encoding => "UTF-8"
        #send_data(@pdf, :filename => "Ticket Summary", :type=>"application/pdf")
      #end
    #end  
    
    # Results are returned as a JSON object
    #redirect_to Net::HTTP.get_response(uri).body
  end
  
  def tickethistory
    @myticketsapihistory = (JSON.load($redis.get("myticketshistroy"))).paginate(:page => params[:page], :per_page => 5)
  end
end
