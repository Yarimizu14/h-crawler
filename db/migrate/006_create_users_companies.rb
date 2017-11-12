class CreateUsersCompanies < ActiveRecord::Migration[5.1]
    def self.up
      create_table :users_companies do |t|
        t.references :user, null: false, index: true
        t.references :company, null: false, index: true

        t.date :start
        t.date :end
      end
    end

    def self.down
      drop_table :users_companies
    end
end