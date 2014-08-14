require 'faker'

task :fake do
  10.times do |n|
    name = Faker::Name.name
    puts name
  end
end