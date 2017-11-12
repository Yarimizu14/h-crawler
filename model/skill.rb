class Skill < ActiveRecord::Base
  has_many :users_skill
  has_many :users, through: :users_skill
end