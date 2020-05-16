# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create!(type: 'monthly', price: 1000, units: 1, active: true, description: 'It\'s a monthly plan. We have to deliver one box.' )
Plan.create!(type: 'half_yearly', price: 900, units: 6, active: true, description: 'It\'s a half yearly plan. We have to deliver 6 boxes, one per month.' )
Plan.create!(type: 'yearly', price: 800, units: 12, active: true, description: 'It\'s a yearly plan. We have to deliver 12 boxes.' )

User.create!(first_name: 'Udit', last_name: 'Mittal', admin: true, email: 'udit@booleans.in', password: 'user1234', password_confirmation: 'user1234')
