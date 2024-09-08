require "test_helper"

class CountryTest < ActiveSupport::TestCase
  self.use_transactional_tests = true

  def setup
    @country = countries(:valid_country)
  end

  test "should create a valid country" do
    assert @country.persisted?
  end

  test "should not save a country, name is blank" do
    @country.name = ""

    assert_not @country.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @country.save! }
  end

  test "should not save a country, name is nil" do
    @country.name = nil

    assert_not @country.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @country.save! }
  end

  test "should not save a country, the country with that name already exists" do
    invalid_country = Country.new
    invalid_country.name = @country.name
    invalid_country.identifier = "RB"

    assert_raises(ActiveRecord::RecordInvalid) { invalid_country.save! }
  end

  test "should not save a country, identifier is nil" do
    @country.identifier = nil

    assert_not @country.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @country.save! }
  end

  test "should not save a country, identifier format is invalid" do
    @country.identifier = "f1"

    assert_not @country.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @country.save! }
  end

  test "should not save a country, identifier is greater than 2" do
    @country.identifier = "fff"

    assert_not @country.valid?
    assert_raises(ActiveRecord::RecordInvalid) { @country.save! }
  end

  test "should not save a country, the country with that identifier already exists" do
    invalid_country = Country.new
    invalid_country.name = "Ruby"
    invalid_country.identifier = @country.identifier

    assert_raises(ActiveRecord::RecordInvalid) { invalid_country.save! }
  end
end
