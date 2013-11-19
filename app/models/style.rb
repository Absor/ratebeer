class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, :through => :beers

  def to_s
    "#{name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -s.average_rating }
    sorted_by_rating_in_desc_order.first(n)
  end
end
