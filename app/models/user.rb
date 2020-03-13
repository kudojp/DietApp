class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :meal_posts

  validates :name, presence: true, length: { maximum: 20 }
  validates :account_id, presence: true, length: { maximum: 15 }, uniqueness: true

  def follow(other_user)
    followings << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def meal_posts_feed
    following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    MealPost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
end
