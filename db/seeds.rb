require 'faker'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts("destory all data we have already...")
Message.destroy_all
Chat.destroy_all
User.destroy_all

puts("seed user...")
users = []
5.times do
  f_email = Faker::Internet.email
  user = User.create(
    email: f_email,
    password: '123456',
    password_confirmation: '123456'
  )
  puts "use user email as #{f_email}, password is: '123456'"
  users << user
end

puts("seed 5 users into database.")
puts("seed chat...")
Chat.create(user_id: users.sample.id, title: "Jobs in Amsterdam" , location: "Amsterdam Nieuw-West", category: "Jobs", description:
                    "Are you looking for a job in Amsterdam? Do you know of any positions available? Join this chat and share tips or information about the job market.")
Chat.create(user_id: users.sample.id, title: "Social Life" , location: "Amsterdam Zuid", category: "Life", description:
                    "Find out about events happening around you, make new friends and discover new places.")
Chat.create(user_id: users.sample.id, title: "Second Hand Stuff" , location: "Amsterdam West", category: "Life", description:
                    "Buy, sell or trade anything here. Furniture, clothes and much more.")
puts("done")
