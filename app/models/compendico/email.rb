# == Schema Information
#
# Table name: compendico_emails
#
#  id                        :uuid             not null, primary key
#  organization_id           :uuid
#  localpart                 :string
#  domain                    :string
#  address                   :string
#  last_sent_at              :datetime
#  sender                    :boolean          default(FALSE)
#  sender_invite_token       :uuid
#  sender_invite_sent_at     :datetime
#  sender_invite_accepted_at :datetime
#  data                      :jsonb
#  external_id               :string
#  to_email_count            :integer          default(0), not null
#  from_email_count          :integer          default(0), not null
#  discarded_at              :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

module Compendico
  class Email < ApplicationRecord
    include Discard::Model

    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

    has_paper_trail

    belongs_to :organization
    counter_culture :organization

    with_options dependent: :destroy do
      has_many :sent_digests,      class_name: 'Digest', foreign_key: 'from_email_id'
      has_many :received_digests,  class_name: 'Digest', foreign_key: 'to_email_id'
    end

    validates :address,
              length: { in: 3..254 },
              format: { with: EMAIL_REGEX },
              presence: true

    def address=(value)
      value = value.to_s.try(:downcase)

      self.localpart, self.domain = self.class.address_splitter(value)

      super(value)
    end

  private

    def self.address_splitter(address)
      address.split('@')
    end
  end
end
