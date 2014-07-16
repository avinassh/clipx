# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
# Environment variables (ENV['...']) can be set in the file .env file.
# Delete all articles, and leave just one
Article.delete_all
article = user.articles.create(
  :url=>'http://getpocket.com/developer/docs/v3/retrieve',
  :title=>'Sample Article',
  :heading=>'Sample Heading',
  :provider=>'pocket',
  :content => 'Sample Content',
  :tags => 'hello, world'
)
puts "Created article: #{article.id.to_s}"