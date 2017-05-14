require 'pg'

class Base

  def execute(query)
    conn = PGconn.connect('localhost',5432,'','', ENV['PG_DBNAME'], ENV['PG_USER'], ENV['PG_PASSWORD'])
    conn.exec(query)
  rescue PGError => ex
    # PGError process
    print(ex.class," -> ",ex.message)
  rescue => ex
    # Other Error  process
    print(ex.class," -> ",ex.message)
  ensure
    conn.close if conn
  end

end
