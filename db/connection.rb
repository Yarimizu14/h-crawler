require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  host:     "localhost",
  username: "postgres",
  password: "password",
  database: "my_db",
)