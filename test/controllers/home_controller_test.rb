require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end
  
  test "should get admin" do
    get admin_url
    assert_response :success
  end
  
  test "should get navigator" do
    get navigator_url
    assert_response :success
  end
  
  test "should get ticketcheck" do
    get checker_url
    assert_response :success
  end
  
  test "should get ticketcheckerresult" do
    get ticketcheckerresult_url
    assert_response :success
  end
  
  test "should get bookticket" do
    get bookticket_url
    assert_response :success
  end
  
  test "should get payment" do
    get payment_url
    assert_response :success
  end
  
  test "should get stripecash" do
    post stripecash_url, params: {stripeEmail: "spkishore007@gmail.com", stripeToken: "dsfdsgdsggdsg"}
    assert_response :success
  end
  
  test "should get ticketconfirmation" do
    get ticketconfirmation_url
    assert_response :success
  end
  
  test "should get tickethistory" do
    get tickethistory_url
    assert_response :success
  end

end
