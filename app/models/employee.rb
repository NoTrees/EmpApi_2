class Employee < ActiveRecord::Base
  # set choices for the dropdown menu in creation and editing of employees
  IS_ADMIN = ['true', 'false']

  # set relationship of employee and work time
  # makes work time dependent on employee
  # if employee is deleted, so are the work times associated with the employee
  has_many :work_time, dependent: :destroy
  
  # provides employee the password used in this app
  # provided password, and password digest
  has_secure_password

  # makes sure that the employee's ID, name, and division are present in creation and editing
  validates_presence_of :id, :name, :division
  # makes sure that the ID remains unique throughout the table
  validates :id, uniqueness: true
  # makes sure that the password is not less that 7 characters
  # allow_nil just lets the app edit employee and work time records without the need to continually providing the password
  validates :password, length: { minimum: 7 }, allow_nil: true
end
