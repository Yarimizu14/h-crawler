require_relative './base'
require 'date'

class Project < Base
  def insert(id)
    t = DateTime.now.iso8601
    q = "INSERT INTO project (id, crawl_datetime)  values (#{id}, '#{t}')"
    self.execute q
  end
end
