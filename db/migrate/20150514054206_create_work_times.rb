class CreateWorkTimes < ActiveRecord::Migration
  def change
    create_table :work_times, id: false do |t|
      t.references :employee, index: true
      t.time :time_of_scan
      t.string :time_flag
      t.date :work_date

      t.timestamps null: false
    end
    add_foreign_key :work_times, :employees
  end
end
