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

module Compendico
  class User < ApplicationRecord
    devise  :database_authenticatable, :recoverable, :registerable,
            :confirmable, :rememberable, :trackable, :validatable

    has_paper_trail

    has_many :organization_users
    has_many :organizations, through: :organization_users

    alias_method :authenticate, :valid_password?

    def self.from_token_payload(payload)
      find_by id: payload['sub']
    end

    def gravatar_url
      "https://www.gravatar.com/avatar/#{::Digest::MD5.hexdigest(email)}"
    end
  end
end
