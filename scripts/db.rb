require 'mysql2'

def db_client
  host = String(ENV["J_DB_HOST"])
  database = String(ENV["J_DB_NAME"])
  username = String(ENV["J_DB_USERNAME"])
  password = String(ENV["J_DB_PASSWORD"])

  Mysql2::Client.new(:host => host, :username => username, :database => database, :password => password)
end