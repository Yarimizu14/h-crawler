class CreateCompanies < ActiveRecord::Migration[5.1]
    def self.up
      create_table :companies, id: false do |t|
        t.integer :id, index: true, primary_key: true
        t.string :name, null: false, unique: true
        t.integer :member_count
        t.integer :follower_count
        t.datetime :founded_on, null: false
      end
    end

    def self.down
      drop_table :companies
    end
end