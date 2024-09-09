namespace :countries do
  desc "Load all countries"
  task load: :environment do
    countries = Extract::Load.call
    Country.insert_all(countries)
  end
end