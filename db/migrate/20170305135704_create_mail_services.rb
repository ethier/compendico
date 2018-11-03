class CreateMailServices < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_mail_services, id: :uuid do |t|
      t.string :name
      t.string :description
      t.boolean :publicly_available, default: false

      t.string :class_name
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
