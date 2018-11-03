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
    has_many :organizations, inverse_of: :plan

    scope :publicly_available, -> { where(publicly_available: true) }
  end
end
