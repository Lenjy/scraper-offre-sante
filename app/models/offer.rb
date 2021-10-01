class Offer < ApplicationRecord
  include ActiveModel::Model
  
  validates :orga, presence: true
  validates :title, presence: true
  validates :orga, uniqueness: {scope: :title}
end
