# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

attrs_array = [
  { name: 'John Doe', email: 'j.doe@example.com', group_id: 1 },
  { name: 'Paula Doe', email: 'p.doe@example.com', group_id: 1 },
  { name: 'Foo Bar', email: 'p.doe@example.com' }
];

Person.destroy_all
puts 'Removed all people!'
puts ?- * 80

attrs_array.each do |attrs|
  Person.create!(attrs)
  puts "- created: #{attrs[:name]}"
end

puts 'Created people!'
