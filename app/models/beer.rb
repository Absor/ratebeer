class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name, :style

  belongs_to :brewery
  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :user
  belongs_to :style

  def to_s
    "#{name} - #{brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -b.average_rating }
    sorted_by_rating_in_desc_order.first(n)
  end
end
