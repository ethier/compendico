# == Schema Information
#
# Table name: compendico_digest_messages
#
#  id         :uuid             not null, primary key
#  digest_id  :uuid
#  message_id :uuid
#  state      :string
#  sent_at    :datetime
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Compendico
  class DigestMessage < ApplicationRecord
    has_paper_trail

    belongs_to :digest
    belongs_to :message

    state_machine initial: :queued do
      after_transition to: :sent, do: :on_sent_entry

      event :digest_sent do
        transition to: :sent, from: :queued
      end

      state :sent do
        validates :sent_at, presence: true
      end
    end

  private

    def on_sent_entry
      update_columns(sent_at: Time.current)
    end
  end
end
