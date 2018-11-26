# == Schema Information
#
# Table name: compendico_billings
#
#  id              :uuid             not null, primary key
#  organization_id :uuid
#  receipt_url     :string
#  amount          :decimal(, )
#  credits         :integer
#  invoice_number  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class Compendico::BillingTest < ActiveSupport::TestCase
  test "set_invoice_number" do
    organization = create(:organization)

    initials = organization.initials
    invoice_identity = organization.invoice_identity

    billing = organization.billings.create

    assert_equal "#{initials}-#{invoice_identity}-0001", billing.invoice_number
  end
end
