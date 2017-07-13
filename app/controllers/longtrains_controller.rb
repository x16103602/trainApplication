require 'httparty'
require 'json'
class LongtrainsController < ApplicationController
  include HTTParty
  before_action :set_longtrain, only: [:show, :edit, :update, :destroy]

  def traininstantiation
  end
  
  def longtraincreation
    @username = User.find(current_user.id)
    @trainobjectposting = HTTParty.post("http://87.44.4.210:8080/api/rest/service/register/", :body => {:id => "", :detail => "Train Ticket Registration", :seatCount => params[:seatCount], :startDate => params[:startDate], :endDate => params[:endDate], :filledSeates => params[:filledSeates], :rType => "Train", :username => "Chennai Railways", :rtocken => ""}.to_json, :headers => {"Content-Type" => "application/json" })
    print(JSON.parse(@trainobjectposting.body))
    if(@trainobjectposting.code == 200) then
      @rtockenstorage = Longtraintocken.new()
      @rtockenstorage.rtocken = (JSON.parse(@trainobjectposting.body))["rtocken"]
      @rtockenstorage.seatcounter =params[:seatCount]
      @rtockenstorage.userauth = @username.userid
      @rtockenstorage.save
      @outfromtrainpost = "Successfully Registered. Please start using it"
    else
      @outfromtrainpost = "Failed, Please Check with the API provider"
    end
  end
  
  def longtrainbook
    seatNos = []
    @username = User.find(current_user.id)
    @longtrainbook = Longtrain.last
    @longtraintegistrationtocken = Longtraintocken.first
    seatNos = (@longtraintegistrationtocken.seatcounter - 1).to_s
    if(@longtrainbook.seat > 1)
      for i in 2..@longtrainbook.seat
        seatNos << " , "
        seatNos << ((@longtraintegistrationtocken.seatcounter) - i).to_s
      end
    end
    @longtraintegistrationtocken.seatcounter = @longtraintegistrationtocken.seatcounter - @longtrainbook.seat
    @longtraintegistrationtocken.save
    @amount = ((@longtrainbook.seat)*15)*100
    customer = Stripe::Customer.create(:email => params[:stripeEmail], :source  => params[:stripeToken])
    charge = Stripe::Charge.create(:customer => customer.id, :amount => @amount, :description => 'Rails Stripe customer', :currency => 'eur')
    #print(charge)
    @longtrainbookpostres = HTTParty.post("http://87.44.4.210:8080/api/rest/service/booking", :body => {:rtocken => @longtraintegistrationtocken.rtocken, :btocken => "", :category => "SuperFast Trains", :boarding => @longtrainbook.boarding, :destination =>  @longtrainbook.destination, :location =>  @longtrainbook.location, :datetime =>  @longtrainbook.datetime, :seat => seatNos, :custId =>  @longtrainbook.custID, :detail =>  "Kishore Company", :id => ""}.to_json, :headers => {"Content-Type" => "application/json" })
    print(@longtrainbookpostres.response)
    print(JSON.parse(@longtrainbookpostres.body))
    if(@longtrainbookpostres.code == 200) then
      @longtrainbook.btocken = (JSON.parse(@longtrainbookpostres.body))["btocken"]
      @longtrainbook.rtocken = Longtraintocken.first.rtocken
      @longtrainbook.save
      @btockenstorage = Longtrainbookingtocken.new()
      @btockenstorage.btocken = (JSON.parse(@longtrainbookpostres.body))["btocken"]
      @btockenstorage.userauth = @username.userid
      @btockenstorage.save
      @longtrainbookingview = []
      @longtrainbookingview[0] = (JSON.parse(@longtrainbookpostres.body))["custId"]
      @longtrainbookingview[1] = (JSON.parse(@longtrainbookpostres.body))["boarding"]
      @longtrainbookingview[2] = (JSON.parse(@longtrainbookpostres.body))["destination"]
      @longtrainbookingview[3] = (JSON.parse(@longtrainbookpostres.body))["datetime"]
      @longtrainbookingview[4] = (JSON.parse(@longtrainbookpostres.body))["seat"]
      @outfromtrainpost = "Successfully Registered. Please start using it"
    else
      @longtrainbookingview = []
      @longtrainbookingview[0] = "Your Ticket is not successful with some unforeseen circumstances."
      @longtrainbookingview << "Kindly check with the support and your payment will be returned back"
      @outfromtrainpost = "Failed, Please Check with the API provider"
    end
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_longtrain_path
    print(charge)
    
  end
  
  def longtrainindex
    @longtrainticketsarray = []
    @longtrainindexcheck = Longtrain.where(user_id: current_user.id)
    @mycounter = 0
    
    if(@longtrainindexcheck) then
      @longtrainindexcheck.each do |check|
        #print(@mycounter)
        @longtrainticketsarrayforpost = HTTParty.post("http://87.44.4.210:8080/api/rest/service/getbooking", :body => {:rtocken => check.rtocken, :btocken => check.btocken}.to_json, :headers => {"Content-Type" => "application/json" })
        print(@longtrainticketsarrayforpost.response)
        print(JSON.parse(@longtrainticketsarrayforpost.body))
        @longtrainticketsarray[@mycounter] = JSON.parse(@longtrainticketsarrayforpost.body)
        @mycounter = @mycounter + 1
        #print("current array object")
        #print(@longtrainticketsarray)
        #end
      end
    else
      @longtrainticketsarray = "No tickets Booked Yet"
    end
  end

  def longtraincancel
    @longtraincancellationcall = HTTParty.delete("http://87.44.4.210:8080/api/rest/service/deleteBooking", :body => {:rtocken => params[:rtocken], :btocken => params[:btocken]}.to_json, :headers => {"Content-Type" => "application/json" })
    print(@longtraincancellationcall.response)
    if(@longtraincancellationcall.code == 200 || @longtraincancellationcall.code == 204)
      @deleteticket = Longtrain.find_by btocken: params[:btocken]
      @deleteticket.destroy
      respond_to do |format|
        format.html { redirect_to longtrainindex_url, notice: 'Longtrain was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to longtrainindex_url, notice: 'Retry Again. Something went wrong'
    end
    
  end
  
  def showonly
  end

  # GET /longtrains
  # GET /longtrains.json
  def index
    @longtrains = Longtrain.all
    #@longtrainalltickets = HTTParty.post("http://87.44.4.210:8080/api/rest/service/getbooking", :body => {:rtocken => Longtrainbookingtocken.first.rtocken, :btocken => Longtraintocken.first.btocken}.to_json, :headers => {"Content-Type" => "application/json" })
    @longtrainget = (HTTParty.get("http://87.44.4.210:8080/api/rest/service/bookings").parsed_response)
    @longtrainsindex = JSON.parse(@longtrainget).paginate(:page => params[:page], :per_page => 5)
    print(@longtrainsindex)
  end

  # GET /longtrains/1
  # GET /longtrains/1.json
  def show
    @longtrain.cost= @longtrain.seat*15
    @longtrain.save
    print(@longtrain)
  end

  # GET /longtrains/new
  def new
    @useroflongtrainid = current_user.id
    @longtrain = Longtrain.new
  end

  # GET /longtrains/1/edit
  def edit
  end

  # POST /longtrains
  # POST /longtrains.json
  def create
    @longtrain = Longtrain.new(longtrain_params)
    @longtrain.user_id = current_user.id
    @longtrain.location = "chennai"
    #@longtrain.rtocken = "kishore"
    @longtrain.category = "SuperFast Trains"
    @longtrain.detail = "Kishore Web application customers"
    
    respond_to do |format|
      if @longtrain.save
        format.html { redirect_to @longtrain, notice: 'Confirm With your Ticket Details' }
        format.json { render :show, status: :created, location: @longtrain }
      else
        format.html { render :new }
        format.json { render json: @longtrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /longtrains/1
  # PATCH/PUT /longtrains/1.json
  def update
    respond_to do |format|
      if @longtrain.update(longtrain_params)
        format.html { redirect_to @longtrain, notice: 'Longtrain was successfully updated.' }
        format.json { render :show, status: :ok, location: @longtrain }
      else
        format.html { render :edit }
        format.json { render json: @longtrain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /longtrains/1
  # DELETE /longtrains/1.json
  def destroy
    @booktrainresponse = HTTParty.post("http://87.44.4.210:8080/api/rest/service/cancelBookings", :body => {:rtocken => Longtraintocken.first.rtocken, :btocken => Longtrainbookingtocken.first.btocken}.to_json, :headers => {"Content-Type" => "application/json" })
    if(@trainobjectposting.response == 200)
      @longtrain.destroy
    else
      redirect_to longtrains_url, notice: 'Retry Again. Something went wrong'
    end
    respond_to do |format|
      format.html { redirect_to longtrains_url, notice: 'Longtrain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_longtrain
      @longtrain = Longtrain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def longtrain_params
      params.require(:longtrain).permit(:boarding, :destination, :datetime, :seat, :custID)
    end
end
