# == Schema Information
#
# Table name: compendico_plans
#
#  id                 :uuid             not null, primary key
#  name               :string
#  price              :decimal(, )
#  credits            :integer
#  publicly_available :boolean          default(FALSE)
#  details            :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

module Compendico
  class Plan < ApplicationRecord
    HOLD_PLAN_NAME = 'Hold'.freeze

    has_many :organizations, inverse_of: :plan

    scope :publicly_available, -> { where(publicly_available: true) }
    scope :hold, -> { where(name: HOLD_PLAN_NAME)}

    def on_hold?
      name.downcase == HOLD_PLAN_NAME
    end
  end
end
