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
User.connection.execute('ALTER SEQUENCE users_id_seq RESTART WITH 1')
password = "password"
counter = 0
20.times do
  User.create(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.email.gsub('@', "-#{counter += 1}@"),
              password_digest: User.new(:password => password).password_digest)
end

50.times do
  date = Faker::Time.between(5.years.ago, Date.today)
  post = Post.create(title: Faker::StarWars.quote,
              body: Faker::Hipster.paragraph,
              created_at: date,
              updated_at: Faker::Time.between(date, Date.today),
              category: Category.find(1+rand(9)),
              user_id: 1 + rand(19))
  rand(5).times do
    cdate = Faker::Time.between(date, Date.today)
    Comment.create( post: post,
                    body: Faker::Hacker.say_something_smart,
                    user_id: 1 + rand(19),
                    created_at: cdate,
                    updated_at: Faker::Time.between(cdate, Date.today))
  end

end
puts "Made the Posts and comments"
