class CompanyMovement < ActiveRecord::Base
  belongs_to :company_from, class_name: "Company", foreign_key: "from_id"
  belongs_to :company_to, class_name: "Company", foreign_key: "to_id"
end