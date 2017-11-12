class CreateProjects < ActiveRecord::Migration[5.1]
    def self.up
      create_table :projects do |t|
        t.string :title, null: false
        t.integer :total_view
        t.datetime :publish_date, null: false
        t.integer :recommendation
        t.references :companies, null: false
      end
    end

    def self.down
      drop_table :projects
    end
end