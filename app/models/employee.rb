class Employee < ActiveRecord::Base
  has_many :work_time
  validates_presence_of :id, :name, :division
  validates :id, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 7 }
end
