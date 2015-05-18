class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :division, null: false
      t.string :authentication, null: false
      t.string :address
      t.text :auth_token

      t.timestamps null: false
    end
  end
end
