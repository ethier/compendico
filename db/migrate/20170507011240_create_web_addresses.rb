class CreateWebAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_web_addresses, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid, index: true

      t.string :category
      t.string :scheme
      t.string :host
      t.string :port
      t.string :path
      t.string :query
      t.string :fragment
      t.string :address, index: true

      t.jsonb :data, default: {}

      t.timestamps null: false
    end

    add_foreign_key :compendico_web_addresses, :compendico_organizations, column: :organization_id
  end
end
