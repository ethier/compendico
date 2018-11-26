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
#  encrypted_payment_token           :string
#  encrypted_payment_token_iv        :string
#  invoice_identity                  :string
#  plan_id                           :uuid
#  mail_service_id                   :uuid
#  credits                           :integer          default(100)
#  renew_automatically               :boolean          default(FALSE)
#  data                              :jsonb
#  templates_count                   :integer          default(0), not null
#  digests_count                     :integer          default(0), not null
#  digests_sent_count                :integer          default(0), not null
#  emails_count                      :integer          default(0), not null
#  billings_count                    :integer          default(0), not null
#  last_billed_at                    :datetime
#  discarded_at                      :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  from_email_id                     :uuid
#

require 'test_helper'

class Compendico::OrganizationTest < ActiveSupport::TestCase
  test "initials" do
    organization_single_name = Compendico::Organization.create(name: 'Name')

    assert_equal 'N', organization_single_name.initials

    organization_plural_name = Compendico::Organization.create(name: 'Plural name')

    assert_equal 'PN', organization_plural_name.initials

    organization_complicated_name = Compendico::Organization.create(name: "Goyette, O'Conner and Lesch")

    assert_equal 'GO', organization_complicated_name.initials
  end

  test "generate api_key and shared_secret" do
    organization = Compendico::Organization.create(name: Faker::Company.name)

    assert_not_nil organization.api_key
    assert_not_nil organization.shared_secret
  end

  test "generate_invoice_identity" do
    organization = Compendico::Organization.create(name: Faker::Company.name)

    assert_not_nil organization.invoice_identity
  end
end
