require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"


set :database, "sqlite3:myblogdb.sqlite3"
enable :sessions

get '/' do
	@posts = Post.all
	@user = current_user
	if @user
		erb :home
	else
		redirect '/sign-in'
	end
end


get '/sign-in' do
	erb :signin
end


post '/sign-in' do
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password] 
		session[:user_id] = @user.id
		redirect '/'    
	else
		redirect '/sign-in'
	end
end

get'/sign-up' do
	erb :create
end

post '/sign-up' do
	@user = User.create(firstname: params[:firstname], lastname: params[:lastname], username: params[:username], email: params[:email], password: params[:password])
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


get '/profile' do
	@posts = Post.all
	@user = current_user
	erb :profile
end



post '/new-post' do
	@user = current_user
	@post = Post.new(title: params[:title], body: params[:body], user_id: current_user.id)
	if !@post.save
		flash[:notice]="Your post was too long. Please try again"
		redirect '/profile'
	else
		flash[:notice]="Thanks for sharing your thoughts!"
        redirect '/profile'
	end
end

post '/new-post-home' do
	@user = current_user
	@post = Post.new(title: params[:title], body: params[:body], user_id: current_user.id)
	if !@post.save
		flash[:notice]="Your post was too long. Please try again"
		redirect '/'
	else
		flash[:notice]="Thanks for sharing your thoughts!"
        redirect '/'
	end
end

	