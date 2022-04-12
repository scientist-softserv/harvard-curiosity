# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# seed the database with users who can access the admin page
admins = [
  { email: 'rob@notch8.com', password: 'testing123'},
  { email: 'support@notch8.com', password: 'testing123'},
  { email: 'admin@example.com', password: 'testing123'}
]
users = [
  { email: 'user@notch8.com', password: 'testing123'},
  { email: 'user@example.com', password: 'testing123'}
]
all_users = admins + users

all_users.each do |set|
  next if User.find_by(email: set[:email])

  user = User.create!(email: set[:email], password: set[:password])
  if admins.map { |admin| admin[:email] }.include?(set[:email])
    user.reload
    user.roles.find_or_create_by!(role: 'admin', resource: Spotlight::Site.first)
  end
end
