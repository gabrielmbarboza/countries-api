require "test_helper"

class CountriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_countries_url
    assert_response :success
  end

  test "should get the pagination of the countries" do
    get api_v1_countries_url
    countries = JSON.parse(@response.body)['data']
    assert_equal countries.size, 15
  end

  test "should get the pagination of the countries with items from page two" do
    get api_v1_countries_url, params: { page: 2 }
    countries = JSON.parse(@response.body)['data']
    assert_equal countries.size, 3
  end

  test "should receive an error because the page doesn't exist" do
    get api_v1_countries_url, params: { page: -1 }
    pagy_error = JSON.parse(@response.body)
    assert_equal pagy_error['error'], "O valor de page deve ser maior ou igual a 1"
    assert_equal @response.status, 400
  end

  test "should show a country" do
    country = countries(:brazil)

    get api_v1_country_url(country)
    assert_response :success

    brazil = JSON.parse(@response.body)

    assert_equal brazil['name'], 'Brasil'
    assert_equal brazil['identifier'], 'BR'
  end

  test "should not show a country because it has not been found" do
    get api_v1_country_url(999999)

    country_not_found = JSON.parse(@response.body)['error']

    assert_match /País não encontrado/, country_not_found
    assert_equal @response.status, 404
  end

  test "should create a country" do
    assert_difference("Country.count") do
      post api_v1_countries_url, params: {
        country: {
          name: "Georgia do Sul",
          identifier: "GS",
          area: "3903",
          location: "Antartica",
          languages: "inglês",
          capital: "Ponto do Rei Eduardo",
          latitude: -54.5,
          longitute: -37,
          population: 30,
          currency_units: "Saint Helena pound (£)",
          timezones: "UTC-02:00",
          osm_code: "1983628",
          history: "Georgia do Sul é uma ilha, território britânico ultramarino, situada no Oceano Atlântico"
        }
      }
    end
  end

  test "should return an error because the country name is nil" do
    post api_v1_countries_url, params: {
      country: {
        name: nil,
        identifier: "WN",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Nome não pode ficar em branco/, country_error.first
    assert_equal @response.status, 422
  end

  test "should return an error because the country name already exists" do
    post api_v1_countries_url, params: {
      country: {
        name: "Brasil",
        identifier: "WN",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Nome deve ser único/, country_error.first
    assert_equal @response.status, 422
  end

  test "should return an error because the identifier name is nil" do
    post api_v1_countries_url, params: {
      country: {
        name: 'Wano',
        identifier: nil,
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador não pode ficar em branco/, country_error.first
    assert_equal @response.status, 422
  end

  test "should return an error because the country identifier is in an invalid format" do
    post api_v1_countries_url, params: {
      country: {
        name: 'Wano',
        identifier: "WN1",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador está com um formato inválido/, country_error.first
    assert_equal @response.status, 422
  end

  test "should return an error because the country identifier already exists" do
    post api_v1_countries_url, params: {
      country: {
        name: "Wano",
        identifier: "BR",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador deve ser único/, country_error.first
    assert_equal @response.status, 422
  end

  test "should update the country" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        name: 'Wano',
        identifier: "WN",
      }
    }

    country.reload

    assert_equal country.name, 'Wano'
    assert_equal country.identifier, 'WN'
  end

  test "should not update the country because the country name is blank" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        name: "",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Nome não pode ficar em branco/, country_error.first
    assert_equal @response.status, 422
  end

  test "should not update the country because the country name already exists" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        name: "Brasil"
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Nome deve ser único/, country_error.first
    assert_equal @response.status, 422
  end

  test "should not update the country because the country identifier is blank" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        identifier: "",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador não pode ficar em branco/, country_error.first
    assert_equal @response.status, 422
  end

  test "should not update the country because the country identifier already exists" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        identifier: "BR"
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador deve ser único/, country_error.first
    assert_equal @response.status, 422
  end

  test "should not update the country because the country identifier is in an invalid format" do
    country = countries(:argentina)

    patch api_v1_country_url(country), params: {
      country: {
        identifier: "WN1",
      }
    }

    country_error = JSON.parse(@response.body)['errors']
    assert_match /Identificador está com um formato inválido/, country_error.first
    assert_equal @response.status, 422
  end

  test "should not update a country because it has not been found" do
    patch api_v1_country_url(999999), params: {
      country: {
        identifier: "WN",
      }
    }

    country_not_found = JSON.parse(@response.body)['error']

    assert_match /País não encontrado/, country_not_found
    assert_equal @response.status, 404
  end

  test "should delete a country" do
    country = countries(:argentina)
    
    delete api_v1_country_url(country)

    assert_equal Country.count, 17
  end

  test "should not delete a country because it has not been found" do
    delete api_v1_country_url(999999)

    country_not_found = JSON.parse(@response.body)['error']

    assert_match /País não encontrado/, country_not_found
    assert_equal @response.status, 404
  end
end
