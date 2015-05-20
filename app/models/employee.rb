class Employee < ActiveRecord::Base
  has_many :work_time
  validates_presence_of :id, :name, :division, :authentication
  validates :authentication, length: { minimum: 7 }
  validates :id, uniqueness: true
end
