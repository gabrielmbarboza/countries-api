class Country < ApplicationRecord
  validates :name, presence: true, uniqueness: true, allow_blank: false
  validates :identifier, presence: true, uniqueness: true, format: { with: /\A[aA-zZ]{2}\Z/ }
end
