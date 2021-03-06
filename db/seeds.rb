# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Employee.delete_all
WorkTime.delete_all

Employee.create(
	  id: '12345',
  	name: 'Emily',
  	division: 'ERD',
  	address: '#123 Drive Street',
    password: '1234567',
    password_confirmation: '1234567',
    is_admin: 'true'
  	)

WorkTime.create(
    employee_id: "12345",
    time_of_scan: '08:00:00',
    time_flag: 'logged_in',
  	work_date: '2015-05-14'
  	)

WorkTime.create(
    employee_id: "12345",
    time_of_scan: '17:00:00',
    time_flag: 'logged_out',
  	work_date: '2015-05-14'
  	)