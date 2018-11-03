# == Schema Information
#
# Table name: compendico_users
#
#  id                     :uuid             not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  data                   :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

module Compendico
  class UserTest < ActiveSupport::TestCase
    # test 'user_created' do
    #   user = Compendico::User.new
    #   user.name = 'Test user'
    #   user.email = 'test@example.com'
    #   user.password = 'testpassword'
    #   user.password_confirmation = 'testpassword'
    #   user.save!
    # end
  end
end
