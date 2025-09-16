# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create the single car model for Henri's dealership
Car.find_or_create_by!(name: "La Voiture Magnifique") do |car|
  car.description = "Une automobile extraordinaire qui transformera votre vie! Cette merveille de l'ingénierie française combine élégance, performance et mystère. Avec son design intemporel et sa couleur noir profond, cette voiture n'est pas seulement un moyen de transport - c'est une déclaration de style, un symbole de sophistication, et votre passeport vers l'aventure!"
  car.price = 25999.99
  car.color = "Noir"
  car.image_url = "/images/la-voiture-magnifique.jpg"
end
