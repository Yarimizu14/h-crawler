class CreateCompanyMovements < ActiveRecord::Migration[5.1]
    def self.up
      create_table :company_movements do |t|
        t.references :from, null: false, index: true
        t.references :to, null: false, index: true
      end
    end

    def self.down
      drop_table :company_movements
    end
end