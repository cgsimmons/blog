class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments, -> {order(created_at: :DESC) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :user

  validates :title, presence: true, uniqueness: true

  def self.search(search_str)
    where("title ILIKE ? OR body ILIKE ?", "%#{search_str}%", "%#{search_str}%")
  end

  def favorite_for(user)
    favorites.find_by(user: user)
  end
end
