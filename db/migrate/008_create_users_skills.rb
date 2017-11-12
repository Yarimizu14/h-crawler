class CreateUsersSkills < ActiveRecord::Migration[5.1]
    def self.up
      create_table :users_skills do |t|
        t.references :user, null: false, index: true
        t.references :skill, null: false, index: true

        t.integer :vote_count
      end
    end

    def self.down
      drop_table :users_skills
    end
end