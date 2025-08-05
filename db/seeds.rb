# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed demo user and apartments
User.destroy_all
Apartment.destroy_all

u = User.create!(email: "demo@example.com", password: "password", password_confirmation: "password")

def create_apartment!(user:, title:, lat:, lng:, city:, price_cents:)
  Apartment.create!(
    user: user,
    title: title,
    description: "Nice apartment in #{city}.",
    latitude: lat,
    longitude: lng,
    price_cents: price_cents,
    size_sqm: rand(30..85),
    rooms: rand(1..3),
    address: "Sample street 1",
    city: city,
    country: "Poland",
    floor: rand(1..8),
    year_built: rand(1970..2020),
    amenities: "{}",
    status: "published",
    available_from: Date.today + rand(1..60)
  )
end

create_apartment!(user: u, title: "Śródmieście Studio", lat: 52.2297, lng: 21.0122, city: "Warsaw", price_cents: 320000)
create_apartment!(user: u, title: "Mokotów 2-room",    lat: 52.1923, lng: 21.0340, city: "Warsaw", price_cents: 450000)
create_apartment!(user: u, title: "Praga Apartment",   lat: 52.2531, lng: 21.0567, city: "Warsaw", price_cents: 380000)

# Demo data: Agadir, Morocco
# Clear existing sample apartments
Apartment.delete_all

user = User.first || User.create!(email: "demo@example.com", password: "password", password_confirmation: "password")

apartments = [
  {
    title: "Agadir Bay Studio",
    description: "Cozy studio near the beach with balcony and sea breeze.",
    city: "Agadir",
    address: "Agadir Bay",
    latitude: 30.3920,
    longitude: -9.5740,
    price_cents: 250000, # 2500.00 in local currency cents assumption
    size_sqm: 32,
    rooms: 1,
    status: "published"
  },
  {
    title: "Marina Apartment",
    description: "Modern 1BR overlooking the marina, great restaurants nearby.",
    city: "Agadir",
    address: "Marina d'Agadir",
    latitude: 30.4250,
    longitude: -9.6240,
    price_cents: 420000,
    size_sqm: 55,
    rooms: 2,
    status: "published"
  },
  {
    title: "City Center 2BR",
    description: "Spacious apartment in the heart of Agadir, close to shops.",
    city: "Agadir",
    address: "Avenue Hassan II",
    latitude: 30.4275,
    longitude: -9.5980,
    price_cents: 520000,
    size_sqm: 70,
    rooms: 3,
    status: "published"
  }
]

apartments.each do |attrs|
  user.apartments.create!(attrs)
end

puts "Seeded: #{User.count} users, #{Apartment.count} apartments"

# Purge existing apartments and seed 10 in Agadir - Hay Mohammedi
puts "Seeding apartments for Agadir - Hay Mohammedi..."

Apartment.delete_all

# Ensure a seed user exists for apartment ownership
seed_user = User.first || User.create!(
  email: "seed@example.com",
  password: "password",
  password_confirmation: "password",
  name: "Seed User"
)

# Approx bounds for Hay Mohammedi, Agadir (rough box)
# Center approx: 30.408, -9.570
lat_min = 30.400
lat_max = 30.420
lng_min = -9.585
lng_max = -9.555

def rand_in_range(min, max)
  rand * (max - min) + min
end

10.times do |i|
  title = "Hay Mohammedi Apt #{i + 1}"
  Apartment.create!(
    title: title,
    city: "Agadir - Hay Mohammedi",
    latitude: rand_in_range(lat_min, lat_max),
    longitude: rand_in_range(lng_min, lng_max),
    price_cents: rand(4000..12000), # 40.00 - 120.00
    status: "published",
    description: "Cozy apartment in Hay Mohammedi, Agadir. Close to local amenities.",
    user: seed_user
  )
end

puts "Seeded #{Apartment.count} apartments in Hay Mohammedi."
