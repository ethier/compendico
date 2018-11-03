# == Schema Information
#
# Table name: compendico_mail_services
#
#  id                 :uuid             not null, primary key
#  name               :string
#  description        :string
#  publicly_available :boolean          default(FALSE)
#  class_name         :string
#  data               :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

module Compendico
  class MailService < ApplicationRecord
    has_many :organizations, inverse_of: :mail_service

    scope :publicly_available, -> { where(publicly_available: true) }
  end
end
