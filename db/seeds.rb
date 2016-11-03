# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do
  Category.create(name: Faker::Company.name)
end
puts 'Seeded categories.'
password = "password"
20.times do
  User.create(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email,
              password_digest: User.new(:password => password).password_digest)
end
puts 'Seeded users.'
50.times do
  date = Faker::Time.between(5.years.ago, Date.today)
  post = Post.create(title: Faker::StarWars.quote,
              body: Faker::Hipster.paragraph,
              created_at: date,
              updated_at: Faker::Time.between(date, Date.today),
              category: Category.all.sample,
              user: User.all.sample)
  rand(5).times do
    cdate = Faker::Time.between(date, Date.today)
    Comment.create( post: post,
                    body: Faker::Hacker.say_something_smart,
                    user: User.all.sample,
                    created_at: cdate,
                    updated_at: Faker::Time.between(cdate, Date.today))
  end

end
puts "Seeded posts and comments"
