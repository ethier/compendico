class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_messages, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid, index: true
      t.belongs_to :template, type: :uuid, index: true

      t.text :text

      t.jsonb :data, default: {}

      t.string :external_id

      t.timestamps
    end

    add_foreign_key :compendico_messages, :compendico_organizations, column: :organization_id
    add_foreign_key :compendico_messages, :compendico_templates, column: :template_id
  end
end
