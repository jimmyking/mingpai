PADRINO_ENV = 'development' unless defined?(PADRINO_ENV)
require File.expand_path('../../config/boot', __FILE__)

task :fake do
  origin_level = [80,90]
  50.times do |n|
    Order.create("type_id" => 1,"order_status_id" => 2, 
    		"department_id" => (rand(2)+1), "acter" => Faker::Name.name,
    		"start_level" => rand(30), "end_level" => origin_level[rand(2)],
    		"acter_account" => Faker::Internet.email,
    		"acter_pw" => Faker::Internet.password,
    		"mobile" => Faker::PhoneNumber.cell_phone,
    		"qq" => Faker::Number.number(9) ,
    		"memo" => Faker::Lorem.sentence)
  end
end