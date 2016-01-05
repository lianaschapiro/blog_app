require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"


set :database, "sqlite3:myblogdb.sqlite3"
enable :sessions



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

post '/sign-up' do
	@user = User.create(username: params[:username], password: params[:password])
	session[:user_id] = @user.id
	redirect '/'
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
	