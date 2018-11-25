class CreateBillings < ActiveRecord::Migration[5.2]
  def change
    create_table :compendico_billings, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid, foreign_key: true
      t.string :receipt_url
      t.decimal :amount
      t.integer :credits
      t.string :invoice_number

      t.timestamps
    end
  end
end
