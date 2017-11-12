require 'active_record'
require './db/connection.rb'

# ActiveRecord::Migration.migrate('db/migrate')
ActiveRecord::Migrator.migrate('./db/migrate')