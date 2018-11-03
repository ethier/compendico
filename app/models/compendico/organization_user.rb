# == Schema Information
#
# Table name: compendico_organization_users
#
#  id              :uuid             not null, primary key
#  organization_id :uuid
#  user_id         :uuid
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module Compendico
  class OrganizationUser < ApplicationRecord
    has_paper_trail

    belongs_to :organization
    belongs_to :user
  end
end
