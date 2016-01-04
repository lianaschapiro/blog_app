require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"


set :database, "sqlite3:myblogdb.sqlite3"
enable :sessions

require "./models"