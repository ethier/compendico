class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :compendico_plans, id: :uuid do |t|
      t.string :name
      t.decimal :price
      t.integer :credits
      t.boolean :publicly_available, default: false

      t.jsonb :details, default: {}

      t.timestamps
    end
  end
end
