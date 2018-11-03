class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_organizations, id: :uuid do |t|
      t.string :name

      t.string :api_key

      t.string :encrypted_shared_secret
      t.string :encrypted_shared_secret_iv

      t.string :encrypted_mail_service_api_key
      t.string :encrypted_mail_service_api_key_iv

      t.belongs_to :plan, type: :uuid
      t.belongs_to :mail_service, type: :uuid

      t.integer :credits, default: 100
      t.boolean :renew_automatically, default: false

      t.jsonb :data, default: {}

      t.integer :templates_count, null: false, default: 0
      t.integer :digests_count, null: false, default: 0
      t.integer :emails_count, null: false, default: 0

      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_foreign_key :compendico_organizations, :compendico_plans, column: :plan_id
    add_foreign_key :compendico_organizations, :compendico_mail_services, column: :mail_service_id
  end
end
