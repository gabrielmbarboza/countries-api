require 'net/http'

module Extract
  module Data
    class Ibge
      def self.load
        country_identifiers = %w[AF ZA AL DE AD AO AG SA DZ AR AM AU AT AZ BS BD BB BH BY BE BZ BJ BO BA BW
                                 BR BN BG BF BI BT CV CM KH CA QA KZ TD CL CN CY CO KM CG CI CR HR CU DK DJ 
                                 DM EG SV AE EC ER SK SI ES US EE SZ ET FJ PH FI FR GA GM GH GE GD GR GT GY
                                 GN GQ GW HT NL HN HU YE MH SB IN ID IR IQ IE IS IL IT JM JP JO KI KW LA LS
                                 LV LB LR LY LI LT LU MK  MG MY MW MV ML MT MA MU MR MX MM FM MZ MD MC MN ME
                                 NA NR NP NI NE NG NO NZ OM PW PA PG PK PY PE PL PT KE KG GB CF KR CD DO KP
                                 CZ RO RW RU WS SM LC KN ST VC SC SN SL RS SG SY SO LK SD SS SE CH SR TJ TH
                                 TZ TL TG TO TT TN TM TR TV UA UG UY UZ VU VE VN ZM ZW]

        ibge_uri = URI.parse("https://servicodados.ibge.gov.br/api/v1/paises/#{country_identifiers.join('%7C')}")

        begin
          ibge_response = Net::HTTP.get_response(ibge_uri)
    
          unless ibge_response.is_a?(Net::HTTPSuccess)
            Rails.logger.error("IBGE returned an error:  #{ibge_response.message} [#{ibge_response.code}]")
            return
          end
    
          ibge_data = JSON.parse(ibge_response.body)

          filtered_ibge_data = ibge_data.uniq {|country| country["id"]["ISO-3166-1-ALPHA-2"]}
    
          filtered_ibge_data.map do |country|
            {
              identifier: country["id"]["ISO-3166-1-ALPHA-2"],
              name: country["nome"]["abreviado"],
              capital: country["governo"]["capital"]["nome"],
              area: country["area"]["total"],
              location: country["localizacao"]["regiao"]['nome'],
              languages: country["linguas"].map{ |language| language["nome"]}.join(','),
              currency_units: country["unidades-monetarias"].map{ |currency| "#{currency["nome"]} (#{currency["id"]["ISO-4217-ALPHA"]})"}.join(','),
              history: country["historico"]
            }
          end
        rescue StandardError => e
          Rails.logger.error(e.message)
          nil
        end
      end
    end
  end
end