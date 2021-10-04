# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p "destoy all Offers"
Offer.all.delete_all

p "Creation Offer from Parisien in progress"
ScraperParisien.new.save_offers
p "offers created"

p "Creation Offer from Bretagne in progress"
ScraperBretagne.new.save_offers
p "offers created"