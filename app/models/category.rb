class Category < ApplicationRecord
  has_many :posts, -> {order(created_at: :DESC) }, dependent: :destroy
  validates :name, presence: true
end
