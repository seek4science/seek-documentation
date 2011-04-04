require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  fixtures :all

  include AuthenticatedTestHelper

  def test_redirected_to_login_if_not_logged_in
    get :index
    assert_response :redirect
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  def test_title
    login_as(:quentin)
    get :index
    assert_select "title",:text=>/The Sysmo SEEK.*/, :count=>1
  end

  test "should get feedback form" do
    login_as(:quentin)
    get :feedback
    assert_response :success
  end  

  test "admin link not visible to non admin" do
    login_as(:aaron)
    get :index
    assert_response :success
    assert_select "a#adminmode[href=?]",admin_path,:count=>0
  end

  test "admin tab visible to admin" do
    login_as(:quentin)
    get :index
    assert_response :success
    assert_select "a#adminmode[href=?]",admin_path,:count=>1
  end

  test "SOP tab should be capitalized" do
    login_as(:quentin)
    get :index
    assert_select "ul.tabnav>li>a[href=?]","/sops",:text=>"SOPs",:count=>1
  end

  test "SOP upload option should be capitlized" do
    login_as(:quentin)
    get :index
    assert_select "select#new_resource_type",:count=>1 do
      assert_select "option[value=?]","sop",:text=>"SOP"
    end
  end

  test "hidden items do not appear in recent items" do
    model = models(:private_model)
    model.title="An updated private model"
    model.save! #to make sure it a recent item

    get :index

    #difficult to use assert_select, because of the way the tabbernav tabs are constructed with javascript onLoad
    assert !@response.body.include?(model.title)
  end


end
