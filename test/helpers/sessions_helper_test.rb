require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

	def setup
		@user = users(:michael)
		remember(@user)
	end

	# TODO テストが通らない原因を調査
	# test "セッションがnilの場合、current_userが正常なユーザーを返す" do
	# 	assert_equal @user, current_user
	# 	assert is_logged_in?
	# end

	test "remember digestが間違っていた場合、current_userがnilを返す" do
		@user.update_attribute(:remember_digest, User.digest(User.new_token))
		assert_nil current_user
	end
end