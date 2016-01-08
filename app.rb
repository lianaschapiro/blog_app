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
		flash[:notice]="You're logged in!"
		redirect '/'    
	else
		flash[:notice]="That didn't seem to work...try again?"
		redirect '/sign-in'
	end
end

get'/sign-up' do
	erb :create
end

post '/sign-up' do
	@user = User.create(firstname: params[:firstname], lastname: params[:lastname], username: params[:username], email: params[:email], password: params[:password])
	session[:user_id] = @user.id
	flash[:notice]="Welcome to Blog It! Post and share!"
	redirect '/'
end


def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end


get '/logout' do
	@user = current_user
	if @user
		session.clear
		flash[:notice]="Come back again soon!"
		redirect '/sign-in'
	else
		redirect 'sign-in'
	end
end


get '/profile' do
	@user = current_user
	if @user
		erb :profile
	else
		redirect '/sign-in'
	end
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

get '/deletepost/:id' do
	post = Post.find(params[:id])
	post.destroy
	flash[:notice]="Your post has been deleted."
	redirect '/profile'
end


get '/delete' do
	@user = current_user
	erb :delete
end


get '/edit-profile' do
	@user = current_user
	erb :editprofile
end


post '/change-username' do
	@user = current_user
	if params[:newusername] == params[:confirmnewusername]
		@user.update(username: params[:confirmnewusername])
		flash[:notice]="Your username has been changed."
		redirect '/edit-profile'
	else
		flash[:notice]="Your usernames don't match."
		redirect '/edit-profile'
	end
end


post '/change-password' do
	@user = current_user
	if params[:oldpassword] == @user.password
		if params[:newpassword] == params[:confirmnewpassword]
			@user.update(password: params[:confirmnewpassword])	
			flash[:notice]="Your password has been changed."
			redirect '/edit-profile'
		else
			flash[:notice]="Your passwords don't match."
			redirect '/edit-profile'
		end
	else
		flash[:notice]="That's not your password."
		redirect '/edit-profile'
	end
end


post '/change-email' do
	@user = current_user
	if params[:newemail] == params[:confirmnewemail]
		@user.update(email: params[:confirmnewemail])
		flash[:notice]="Your email has been changed."
		redirect '/edit-profile'
	else
		flash[:notice]="Your emails don't match."
		redirect '/edit-profile'
	end
end


get '/dead-user' do
	@user = current_user
	@user.destroy
	flash[:notice]="We will miss you!"
	redirect '/sign-up'
end

get '/:username' do
	@posts = Post.all
	@user = current_user
	@person = User.where(username: params[:username]).first
	erb :otherpersonprofile
end
	