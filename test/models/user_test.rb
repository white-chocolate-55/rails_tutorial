require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com",
  									 password: "foobar", password_confirmation: "foobar")
  end

  test "有効なユーザーか否か" do
  	assert @user.valid?
  end

  test "名前の存在性の検証" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "有効なメールアドレスの検証" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
	  	@user.email = valid_address
	  	assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "無効なメールアドレスの検証" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  	end
  end

  test "メールアドレスが一意であること" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "メールアドレスが小文字で保存されること" do
  	mixed_case_email = "Foo@ExAMPle.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "パスワードが空でないこと" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "パスワードが６文字以上であること" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

end
