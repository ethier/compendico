class CreateDigests < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_digests, id: :uuid do |t|
      t.string :subject

      t.uuid :to_email_id, index: true
      t.uuid :from_email_id, index: true

      t.belongs_to :organization, type: :uuid, index: true
      t.belongs_to :template, type: :uuid, index: true

      t.text :full_message

      t.datetime :sending_at
      t.datetime :sent_at
      t.datetime :failed_at

      t.integer :frequency
      t.string :interval
      t.datetime :send_at

      t.string :state

      t.jsonb :data, default: {}
      t.text :text

      t.string :external_id

      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_index :compendico_digests, [:to_email_id, :from_email_id, :organization_id, :subject], name: :to_from_organization_subject, unique: true
    add_foreign_key :compendico_digests, :compendico_organizations, column: :organization_id
    add_foreign_key :compendico_digests, :compendico_templates, column: :template_id
  end
end
