class WorkTime < ActiveRecord::Base
  belongs_to :employee
  validates_presence_of :employee, :employee_id
end
