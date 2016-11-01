 #encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	db = SQLite3::Database.new'Barbershop_data.db'
	db.execute'CREATE TABLE IF NOT EXISTS `Users` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`user_name`	TEXT,
	`phone`	TEXT,
	`data_time`	TEXT,
	`barber`	TEXT,
	`color`	TEXT
	);'
end

get '/' do
	erb "Hello, world! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School </a>"
end

get '/about' do
	@error = 'something wrong'
  erb :about
end

get '/enrol' do
  erb :enrol
end

post '/enrol' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@data_time = params[:data_time]
	@barber = params[:barber]
	@color = params[:color]

	hh = {:user_name => "Enter name",
				:phone => "Enter phone",
				:data_time => "Enter data and time"}

	@error = hh.select{|key,_|  params[key] == ""}.values.join(",")

	if @error != ''
		return erb :enrol
	end

	erb "OK!, #{@user_name}, #{@phone}, #{@data_time}, #{@barber}, #{@color}"
end
