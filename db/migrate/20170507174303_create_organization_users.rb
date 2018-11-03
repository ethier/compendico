class CreateOrganizationUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_organization_users, id: :uuid do |t|
      t.belongs_to :organization, type: :uuid
      t.belongs_to :user, type: :uuid

      t.timestamps
    end

    add_foreign_key :compendico_organization_users, :compendico_organizations, column: :organization_id
    add_foreign_key :compendico_organization_users, :compendico_users, column: :user_id
  end
end
