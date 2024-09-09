require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:limit] = 15
Pagy::DEFAULT[:overflow] = :empty_page