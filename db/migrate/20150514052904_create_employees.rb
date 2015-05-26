class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :division, null: false
      t.string :authentication
      t.string :address
      t.string :is_admin, default: false

      t.timestamps null: false
    end
  end
end
