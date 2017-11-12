class User < ActiveRecord::Base
  has_many :users_school
  has_many :schools, through: :users_school

  has_many :users_company
  has_many :companies, through: :users_company

  has_many :users_skill
  has_many :skills, through: :users_skill
end