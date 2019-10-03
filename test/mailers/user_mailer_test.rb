require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:michael)
    user.activation_token = User.new_token

    mail = UserMailer.account_activation(user)
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['noreply@example.org'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

  # test 'passsword_reset' do
  #   mail = UserMailer.passsword_reset
  #   assert_equal 'Passsword reset', mail.subject
  #   assert_equal %w[to@example.org], mail.to
  #   assert_equal %w[from@example.com], mail.from
  #   assert_match 'Hi', mail.body.encoded
  # end
end
