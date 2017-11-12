class CreateSchools < ActiveRecord::Migration[5.1]
    def self.up
      create_table :schools do |t|
        t.string :name, null: false
      end
    end

    def self.down
      drop_table :schools
    end
end