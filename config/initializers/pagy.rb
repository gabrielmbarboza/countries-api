require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
require 'pagy/extras/searchkick'

Searchkick.extend Pagy::Searchkick

Pagy::DEFAULT[:limit] = 15
Pagy::DEFAULT[:overflow] = :empty_page