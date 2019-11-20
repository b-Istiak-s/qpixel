require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "should get new answer page" do
    sign_in users(:standard_user)
    get :new, params: { id: posts(:question_one).id }
    assert_response(200)
    assert_not assigns(:answer).nil?
    assert_not assigns(:question).nil?
  end

  test "should create new answer" do
    sign_in users(:standard_user)
    post :create, params: { answer: { body: "ABCDEF GHIJKL MNOPQR STUVWX YZ" }, id: posts(:question_one).id }
    assert_not assigns(:answer).nil?
    assert_not assigns(:question).nil?
    assert_response(302)
  end

  test "should get edit answer page" do
    sign_in users(:editor)
    get :edit, params: { id: posts(:answer_one).id }
    assert_response(200)
    assert_not assigns(:answer).nil?
  end

  test "should update existing answer" do
    sign_in users(:editor)
    patch :update, params: { answer: { body: "ABCDEF GHIJKL MNOPQR STUVWX YZ" }, id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_response(302)
  end

  test "should mark answer deleted" do
    sign_in users(:deleter)
    delete :destroy, params: { id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_equal true, assigns(:answer).deleted
    assert_not assigns(:answer).deleted_at.nil?
    assert_response(302)
  end

  test "should mark answer undeleted" do
    sign_in users(:deleter)
    delete :undelete, params: { id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_equal false, assigns(:answer).deleted
    assert_not assigns(:answer).deleted_at.nil?
    assert_response(302)
  end

  test "should require authentication to get new page" do
    sign_out :user
    get :new, params: { id: posts(:question_one).id }
    assert_response(302)
  end

  test "should require authenitcation to create answer" do
    sign_out :user
    post :create, params: { id: posts(:question_one).id }
    assert_response(302)
  end

  test "should require authentication to get edit page" do
    sign_out :user
    get :edit, params: { id: posts(:answer_one).id }
    assert_response(302)
  end

  test "should require authentication to update answer" do
    sign_out :user
    patch :update, params: { id: posts(:answer_one).id }
    assert_response(302)
  end

  test "should require user to have edit privileges to get edit page" do
    sign_in users(:standard_user)
    get :edit, params: { id: posts(:answer_two).id }
    assert_response(401)
  end

  test "should require user to have edit privileges to update answer" do
    sign_in users(:standard_user)
    patch :update, params: { id: posts(:answer_two).id }
    assert_response(401)
  end

  test "should require authentication to delete" do
    sign_out :user
    delete :destroy, params: { id: posts(:answer_one).id }
    assert_response(302)
  end

  test "should require authentication to undelete" do
    sign_out :user
    delete :undelete, params: { id: posts(:answer_one).id }
    assert_response(302)
  end

  test "should require above standard privileges to delete" do
    sign_in users(:standard_user)
    delete :destroy, params: { id: posts(:answer_two).id }
    assert_response(401)
  end

  test "should require above standard privileges to undelete" do
    sign_in users(:standard_user)
    delete :undelete, params: { id: posts(:answer_two).id }
    assert_response(401)
  end

  test "should require above edit privileges to delete" do
    sign_in users(:editor)
    delete :destroy, params: { id: posts(:answer_one).id }
    assert_response(401)
  end

  test "should require above edit privileges to undelete" do
    sign_in users(:editor)
    delete :undelete, params: { id: posts(:answer_one).id }
    assert_response(401)
  end

  test "should allow author to get edit page" do
    sign_in users(:standard_user)
    get :edit, params: { id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_response(200)
  end

  test "should allow author to update answer" do
    sign_in users(:standard_user)
    patch :update, params: { answer: { body: "ABCDEF GHIJKL MNOPQR STUVWX YZ" }, id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_response(302)
  end

  test "should allow author to delete answer" do
    sign_in users(:standard_user)
    delete :destroy, params: { id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_response(302)
  end

  test "should allow author to undelete answer" do
    sign_in users(:standard_user)
    delete :undelete, params: { id: posts(:answer_one).id }
    assert_not assigns(:answer).nil?
    assert_response(302)
  end

  test "should block short answers" do
    sign_in users(:standard_user)
    post :create, params: { answer: { body: "ABCDEF" }, id: posts(:question_one).id }
    assert_response(422)
  end

  test "should block whitespace answers" do
    sign_in users(:standard_user)
    post :create, params: { answer: { body: " "*31 }, id: posts(:question_one).id }
    assert_response(422)
  end

  test "should block long answers" do
    sign_in users(:standard_user)
    post :create, params: { answer: { body: "A"*(3e4+1) }, id: posts(:question_one).id }
    assert_response(422)
  end
end
