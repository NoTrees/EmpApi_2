class WorkTime < ActiveRecord::Base
  TIME_FLAG = ['logged_in', 'logged_out']

  belongs_to :employee
  validates_presence_of :employee, :employee_id
end
