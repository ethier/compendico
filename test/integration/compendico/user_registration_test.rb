require 'test_helper'

module Compendico
  class UserRegistrationTest < ActionDispatch::IntegrationTest
    test 'user_registration_creates_email' do
      assert_difference('Compendico::User.count') do
        user_registration_params = {
          'user[email]': 'test@example.com',
          'user[password]': 'testpassword',
          'user[password_confirmation]': 'testpassword'
        }
        post user_registration_url, params: user_registration_params
      end
    end
  end
end
