# == Schema Information
#
# Table name: compendico_templates
#
#  id              :uuid             not null, primary key
#  organization_id :uuid
#  category        :string
#  name            :string
#  markup          :text
#  external_id     :integer
#  data            :jsonb
#  discarded_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Compendico
  class Template < ApplicationRecord
    include Discard::Model

    ALLOWED_CATEGORIES = %w(digest message).freeze

    has_paper_trail

    belongs_to :organization
    counter_culture :organization

    has_many :messages, inverse_of: :template

    validates :name,      presence: true
    validates :markup,    presence: true
    validates :category,  presence: true, inclusion: { in: ALLOWED_CATEGORIES }

    scope :digests,  -> { where(category: 'digest') }
    scope :messages, -> { where(category: 'message') }

    def self.categories
      ALLOWED_CATEGORIES
    end
  end
end
