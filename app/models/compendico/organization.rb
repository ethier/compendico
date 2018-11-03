# == Schema Information
#
# Table name: compendico_organizations
#
#  id                                :uuid             not null, primary key
#  name                              :string
#  api_key                           :string
#  encrypted_shared_secret           :string
#  encrypted_shared_secret_iv        :string
#  encrypted_mail_service_api_key    :string
#  encrypted_mail_service_api_key_iv :string
#  plan_id                           :uuid
#  mail_service_id                   :uuid
#  credits                           :integer          default(100)
#  renew_automatically               :boolean          default(FALSE)
#  data                              :jsonb
#  templates_count                   :integer          default(0), not null
#  digests_count                     :integer          default(0), not null
#  emails_count                      :integer          default(0), not null
#  discarded_at                      :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  from_email_id                     :uuid
#

module Compendico
  class Organization < ApplicationRecord
    include Discard::Model

    has_paper_trail

    attribute :shared_secret
    attribute :mail_service_api_key

    attr_encrypted :shared_secret, key: :encryption_key
    attr_encrypted :mail_service_api_key, key: :encryption_key

    belongs_to :plan
    belongs_to :mail_service

    belongs_to  :from_email,
                class_name: 'Email',
                autosave: false

    has_many :organization_users
    has_many :users, through: :organization_users

    with_options inverse_of: :organization do
      has_many :emails
      has_many :digests
      has_many :messages
      has_many :templates
      has_many :web_addresses
    end

    before_validation :generate_api_key_shared_secret, on: :create

    validates :api_key, :shared_secret, presence: true

    accepts_nested_attributes_for :from_email

    def encryption_key
      Rails.application.credentials.secret_key_base
    end

    def website
      web_address_by_category(:website).last.try(:address)
    end

    def website=(address)
      if new_record?
        build_web_address_by_category(:website, address)
      else
        update_web_address_by_category(:website, address)
      end
    end

    def webhook_callback_url
      web_address_by_category(:webhook_callback).last.try(:address)
    end

    def webhook_callback_url=(address)
      if new_record?
        build_web_address_by_category(:webhook_callback, address)
      else
        update_web_address_by_category(:webhook_callback, address)
      end
    end

    def initials
      name.split.map(&:first)[0..1].join
    end

  private

    def web_address_by_category(category)
      web_addresses.where(category: category.to_s)
    end

    def build_web_address_by_category(category, address)
      web_addresses.build(category: category.to_s, address: address)
    end

    def update_web_address_by_category(category, address)
      web_address_by_category(category)
        .where(address: address)
        .first_or_create!
    end

    def generate_api_key_shared_secret
      self.api_key        = SecureRandom.urlsafe_base64
      self.shared_secret  = SecureRandom.urlsafe_base64(64)
    end
  end
end