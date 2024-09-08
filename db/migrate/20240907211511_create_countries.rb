class CreateCountries < ActiveRecord::Migration[7.2]
  def change
    create_table :countries do |t|
      t.string :name, null: false, index: { unique: true, name: 'unique_name' }
      t.string :identifier, null: false, index: { unique: true, name: 'unique_identifier' }
      t.string :area
      t.string :location
      t.string :languages
      t.string :capital
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitute, precision: 10, scale: 6
      t.decimal :population, precision: 15, scale: 2
      t.string :currency_units
      t.string :timezones
      t.string :osm_code
      t.string :history

      t.timestamps
    end
  end
end
