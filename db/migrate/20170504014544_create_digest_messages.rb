class CreateDigestMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_digest_messages, id: :uuid do |t|
      t.belongs_to :digest, type: :uuid, index: true
      t.belongs_to :message, type: :uuid, index: true

      t.string :state

      t.datetime :sent_at
      t.jsonb :data, default: {}

      t.timestamps
    end

    add_foreign_key :compendico_digest_messages, :compendico_digests, column: :digest_id
    add_foreign_key :compendico_digest_messages, :compendico_messages, column: :message_id
  end
end
