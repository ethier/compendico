class CreateBillings < ActiveRecord::Migration[5.2]
  def change
    create_table :compendico_billings, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid, index: true

      t.string :receipt_url
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.integer :credits
      t.string :invoice_number

      t.timestamps
    end

    add_foreign_key :compendico_billings, :compendico_organizations, column: :organization_id
  end
end
