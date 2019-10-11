class List < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user
  validates :user, uniqueness: { scope: :restaurant}
end
