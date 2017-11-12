class Company < ActiveRecord::Base
  has_many :project

  has_many :movement_from, class_name: "CompanyMovement", foreign_key: "from_id"
  has_many :to_companies, through: :movement_from, source: 'company_to'

  has_many :movement_to, class_name: "CompanyMovement", foreign_key: "to_id"
  has_many :from_companies, through: :movement_to, source: 'company_from'
end