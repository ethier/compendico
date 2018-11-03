class AddFromEmailToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :compendico_organizations, :from_email_id, :uuid, index: true
  end
end
