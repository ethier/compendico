# == Schema Information
#
# Table name: compendico_web_addresses
#
#  id              :uuid             not null, primary key
#  organization_id :uuid
#  category        :string
#  scheme          :string
#  host            :string
#  port            :string
#  path            :string
#  query           :string
#  fragment        :string
#  address         :string
#  data            :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Compendico
  class WebAddress < ApplicationRecord
    SCHEMES = %w[http https].freeze
    CATEGORIES = %w[website webhook_callback].freeze

    has_paper_trail

    belongs_to :organization

    validates :address, presence: true
    validates_inclusion_of :category, in: CATEGORIES

    def address=(value)
      super(value)

      if valid_web_address?
        split_address
      else
        errors.add(:address, :invalid)

        super(nil)

        self.scheme   = nil
        self.host     = nil
        self.port     = nil
        self.path     = nil
        self.query    = nil
        self.fragment = nil
      end
    end

  private

    def split_address
      self.scheme   = uri_parsed_web_address.scheme
      self.host     = uri_parsed_web_address.host
      self.port     = uri_parsed_web_address.port
      self.path     = uri_parsed_web_address.path
      self.query    = uri_parsed_web_address.query
      self.fragment = uri_parsed_web_address.fragment
    end

    def valid_web_address?
      parsed = uri_parsed_web_address or return false
      SCHEMES.include?(parsed.scheme)
    rescue Addressable::URI::InvalidURIError
      false
    end

    def uri_parsed_web_address
      @address ||= Addressable::URI.parse(address)
    end
  end
end
