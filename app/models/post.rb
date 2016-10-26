class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments, -> {order(created_at: :DESC) }, dependent: :destroy
  validates :title, presence: true, uniqueness: true

  def self.search(search_str)
    where("title ILIKE ? OR body ILIKE ?", "%#{search_str}%", "%#{search_str}%")
  end
end
