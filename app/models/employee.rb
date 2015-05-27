class Employee < ActiveRecord::Base
  has_many :work_time
  has_secure_password
  validates_presence_of :id, :name, :division
  validates :id, uniqueness: true
  validates :password, length: { minimum: 7 }, allow_nil: true
end
