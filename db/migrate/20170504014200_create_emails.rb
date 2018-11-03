class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_emails, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid, index: true

      t.string :localpart
      t.string :domain
      t.string :address, null: false, index: true
      t.string :name
      t.datetime :last_sent_at

      t.boolean :sender, null: false, default: false
      t.uuid :sender_invite_token
      t.datetime :sender_invite_sent_at
      t.datetime :sender_invite_accepted_at

      t.jsonb :data, default: {}

      t.string :external_id

      t.integer :to_email_count, null: false, default: 0
      t.integer :from_email_count, null: false, default: 0

      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_index :compendico_emails, [:address, :organization_id], unique: true
    add_foreign_key :compendico_emails, :compendico_organizations, column: :organization_id
  end
end
