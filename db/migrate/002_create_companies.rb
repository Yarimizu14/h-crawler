class CreateCompanies < ActiveRecord::Migration[5.1]
    def self.up
      execute 'CREATE SEQUENCE companies_id_seq;'
      create_table :companies, id: false do |t|
        t.integer :id, index: true, "SET DEFAULT nextval('scores_job_id_seq')": true
        t.string :name, primary_key: true
        t.integer :member_count
        t.integer :follower_count
        t.datetime :founded_on, null: false
      end
    end

    def self.down
      drop_table :companies
    end
end