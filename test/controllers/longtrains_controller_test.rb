require 'test_helper'

class LongtrainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @longtrain = longtrains(:one)
  end

  test "should get index" do
    get longtrains_url
    assert_response :success
  end

  test "should get new" do
    get new_longtrain_url
    assert_response :success
  end

  test "should create longtrain" do
    assert_difference('Longtrain.count') do
      post longtrains_url, params: { longtrain: { boarding: @longtrain.boarding, btocken: @longtrain.btocken, category: @longtrain.category, custID: @longtrain.custID, datetime: @longtrain.datetime, destination: @longtrain.destination, location: @longtrain.location, rtocken: @longtrain.rtocken, seat: @longtrain.seat, user_id: @longtrain.user_id } }
    end

    assert_redirected_to longtrain_url(Longtrain.last)
  end

  test "should show longtrain" do
    get longtrain_url(@longtrain)
    assert_response :success
  end

  test "should get edit" do
    get edit_longtrain_url(@longtrain)
    assert_response :success
  end

  test "should update longtrain" do
    patch longtrain_url(@longtrain), params: { longtrain: { boarding: @longtrain.boarding, btocken: @longtrain.btocken, category: @longtrain.category, custID: @longtrain.custID, datetime: @longtrain.datetime, destination: @longtrain.destination, location: @longtrain.location, rtocken: @longtrain.rtocken, seat: @longtrain.seat, user_id: @longtrain.user_id } }
    assert_redirected_to longtrain_url(@longtrain)
  end

  test "should destroy longtrain" do
    assert_difference('Longtrain.count', -1) do
      delete longtrain_url(@longtrain)
    end

    assert_redirected_to longtrains_url
  end
end
