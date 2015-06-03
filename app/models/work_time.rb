class WorkTime < ActiveRecord::Base
  # set choices for the dropdown menu in creation and editing of work times
  TIME_FLAG = ['logged_in', 'logged_out']

  # set relationship of work time and employee
  # also makes available the employee_id to work time
  belongs_to :employee

  # makes sure that an employee with employee_id is existent in the employee table
  validates_presence_of :employee, :employee_id
end
