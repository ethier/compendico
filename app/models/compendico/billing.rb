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

class Compendico::Billing < ApplicationRecord
  belongs_to :organization
  counter_culture :organization

  before_validation :set_invoice_number, on: :create

  after_save :save_generated_receipt

  private

  def set_invoice_number
    self.invoice_number =
      "#{organization.initials}-#{organization.invoice_identity}-#{(organization.billings_count + 1).to_s.rjust(4, '0')}"
  end

  def save_generated_receipt
    # TODO: Setup the AWS storage of receipts.
  end
end
