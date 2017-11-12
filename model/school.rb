class School < ActiveRecord::Base
  has_many :users_school
  has_many :users, through: :users_school
end