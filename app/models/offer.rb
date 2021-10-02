class Offer < ApplicationRecord
  validates :orga, presence: true
  validates :title, presence: true
  validates :orga, uniqueness: {scope: :title}
end
