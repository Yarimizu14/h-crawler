class CreateSkills < ActiveRecord::Migration[5.1]
    def self.up
      create_table :skills do |t|
        t.string :name, null: false
      end
    end

    def self.down
      drop_table :skills
    end
end