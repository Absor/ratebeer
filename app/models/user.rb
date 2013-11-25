class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 4
  validates_length_of :username, :minimum => 3, :maximum => 15
  validates :password, :format => {:without => /\A[a-zA-Z]*\Z/, :message => 'must contain at least one number or special character.'}

  has_many :ratings, :dependent => :destroy
  has_many :beers, :through => :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, :through => :memberships

  def unconfirmed_memberships
    memberships.includes(:beer_club).where(confirmed: [nil, false])
  end

  def confirmed_memberships
    memberships.includes(:beer_club).where(confirmed: true)
  end

  def favorite_beer
    return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    return nil if ratings.empty?
    ratings_by_style = ratings.group_by{|r| r.beer.style}

    ratings_by_style.each do |style, ratings|
      ratings_by_style[style] = ratings.inject(0.0) {|sum, item| sum + item.score} / ratings.count
    end

    ratings_by_style.sort_by{|key, value| value}.last[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    ratings_by_brewery = ratings.group_by{|r| r.beer.brewery}

    ratings_by_brewery.each do |brewery, ratings|
      ratings_by_brewery[brewery] = ratings.inject(0.0) {|sum, item| sum + item.score} / ratings.count
    end

    ratings_by_brewery.sort_by{|key, value| value}.last[0].name
  end

  def self.most_active(n)
    sorted_by_ratings_in_desc_order = User.all.sort_by{ |u| -u.ratings.count }
    return sorted_by_ratings_in_desc_order.first(n)
  end
end
