require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end
  
  test "無効な情報でログインをした場合" do
  	get login_path
  	assert_template 'sessions/new'
  	post login_path, params: { session: { email: "", password: "" } }
  	assert_template 'sessions/new'
  	get root_path
  	assert flash.empty?
  end

  test "有効な情報でログインした場合" do
  	get login_path
  	post login_path, params: { session: { email: @user.email, password: 'password' } }
  	assert_redirected_to @user
  	follow_redirect!
  	assert_template 'users/show'
  	assert_select "a[href=?]", login_path, count: 0
  	assert_select "a[href=?]", logout_path
  	assert_select "a[href=?]", user_path(@user)
  end
end
