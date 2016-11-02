 #encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where barber_name = ?', [name]).size > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute'insert into Barbers (barber_name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new'Barbershop_data.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute'select * from Barbers '
end

configure do
	db = get_db
	db.execute'CREATE TABLE IF NOT EXISTS `Users` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`user_name`	TEXT,
	`phone`	TEXT,
	`data_time`	TEXT,
	`barber`	TEXT,
	`color`	TEXT
	);'

	db.execute'CREATE TABLE IF NOT EXISTS `Barbers` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`barber_name`	TEXT
	);'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Pavel Sernov']
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

	db = get_db
	db.execute 'INSERT INTO Users (user_name, phone, data_time, barber, color) values (?,?,?,?,?)',
	[@user_name, @phone, @data_time, @barber, @color]

	erb "OK!, #{@user_name}, #{@phone}, #{@data_time}, #{@barber}, #{@color}"
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
  erb :show_users
end
