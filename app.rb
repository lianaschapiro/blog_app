require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"


set :database, "sqlite3:myblogdb.sqlite3"
enable :sessions

require "./models"

get '/sign-in' do

		erb :signin
end

post '/sign-in' do

	@user = User.where(username: params[:username]).first

	if @user && @user.password == params[:password] 
		session[:user_id] = @user_id
		redirect '/'
    
	else
		redirect '/sign-in'
	end
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/logout' do
	 session.clear
	 redirect '/sign-in'
	end
	