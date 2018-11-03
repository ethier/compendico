class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_templates, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid

      t.string :category
      t.string :name
      t.text :markup
      t.integer :external_id
      t.jsonb :data, default: {}

      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_foreign_key :compendico_templates, :compendico_organizations, column: :organization_id
    add_index :compendico_templates, [:organization_id, :name, :category], name: :index_templates_on_organization_id_name_and_category, unique: true
  end
end
