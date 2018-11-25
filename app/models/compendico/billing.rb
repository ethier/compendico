class Compendico::Billing < ApplicationRecord
  belongs_to :organization
  counter_culture :organization

  before_validation :set_invoice_number, on: :create

  after_save :save_generated_receipt

  private

  def set_invoice_number
    self.invoice_number =
      "{organization.invoice_identity}-{(organizaton.billings_count + 1).to_s.rjust(4, '0')}"
  end

  def save_generated_receipt
    # TODO: Setup the AWS storage of receipts.
  end
end
