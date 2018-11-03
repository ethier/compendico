# == Schema Information
#
# Table name: compendico_messages
#
#  id              :uuid             not null, primary key
#  organization_id :uuid
#  template_id     :uuid
#  text            :text
#  data            :jsonb
#  external_id     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Compendico
  class Message < ApplicationRecord
    include TemplateParser

    has_paper_trail

    acts_as_taggable

    belongs_to :organization
    belongs_to :template, optional: true

    has_many :digest_messages
    has_many :digests, through: :digest_messages

    after_save :broadcast, if: :broadcastable?

    def render
      parsed_template.render(JSON.parse(data))
    end

  private

    def broadcastable?
      true
    end

    def broadcast
      digests.find_each(&:broadcast)
    end
  end
end
