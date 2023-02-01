require 'mysql2'

def db_client
  host = String('localhost')
  database = String('japan')
  username = String('root')
  password = String('testtest')

  Mysql2::Client.new(:host => host, :username => username, :database => database, :password => password)
end