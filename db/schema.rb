# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150526064303) do

  create_table "employees", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "division",                          null: false
    t.string   "authentication"
    t.string   "address"
    t.string   "is_admin",        default: "false"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
  end

  create_table "work_times", force: :cascade do |t|
    t.integer  "employee_id"
    t.time     "time_of_scan"
    t.string   "time_flag"
    t.date     "work_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "work_times", ["employee_id"], name: "index_work_times_on_employee_id"

end
