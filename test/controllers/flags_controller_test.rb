require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "should create new flag" do
    sign_in users(:standard_user)
    post :new, params: { reason: "ABCDEF GHIJKL MNOPQR STUVWX YZ", post_id: posts(:answer_two).id, post_type: 'Answer' }
    assert_not assigns(:flag).nil?
    assert_not assigns(:flag).post.nil?
    assert_equal 'success', JSON.parse(response.body)['status']
    assert_response(201)
  end

  test "should retrieve flag queue" do
    sign_in users(:moderator)
    get :queue
    assert_not assigns(:flags).nil?
    assert_response(200)
  end

  test "should add status to flag" do
    sign_in users(:moderator)
    post :resolve, params: { id: flags(:one).id, result: "ABCDEF", message: "ABCDEF GHIJKL MNOPQR STUVWX YZ" }
    assert_not assigns(:flag).nil?
    assert_not assigns(:flag).flag_status.nil?
    assert_equal 'success', JSON.parse(response.body)['status']
    assert_response(200)
  end

  test "should require authentication to create flag" do
    sign_out :user
    post :new
    assert_response(302)
  end

  test "should require authentication to get queue" do
    sign_out :user
    get :queue
    assert_response(302)
  end

  test "should require moderator status to get queue" do
    sign_in users(:standard_user)
    get :queue
    assert_response(404)
  end

  test "should require authentication to resolve flag" do
    sign_out :user
    post :resolve, params: { id: flags(:one).id }
    assert_response(302)
  end

  test "should require moderator status to resolve flag" do
    sign_in users(:standard_user)
    post :resolve, params: { id: flags(:one).id }
    assert_response(404)
  end

  test "should prevent short reasons" do
    sign_in users(:standard_user)
    post :new, params: { reason: "ABCDEF", post_id: posts(:answer_two).id, post_type: 'Answer' }
    assert_equal 'Flag failed to save.', JSON.parse(response.body)['message']
    assert_equal 'failed', JSON.parse(response.body)['status']
    assert_response(500)
  end

  test "should prevent long reasons" do
    sign_in users(:standard_user)
    post :new, params: { reason: "ABCDEF" * 1000, post_id: posts(:answer_two).id, post_type: 'Answer' }
    assert_equal 'Flag failed to save.', JSON.parse(response.body)['message']
    assert_equal 'failed', JSON.parse(response.body)['status']
    assert_response(500)
  end
end
