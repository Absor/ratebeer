class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, :presence => true
  validates_numericality_of :year, {:greater_than_or_equal_to => 1042,
                                    :only_integer => true}
  validate :year_can_not_be_in_the_future

  has_many :beers
  has_many :ratings, :through => :beers

  scope :active, -> { where(:active => true) }
  scope :retired, -> { where(:active => [nil, false]) }

  def year_can_not_be_in_the_future
     if not year.nil? and year >= Time.now.year
       errors.add(:year, "can not be in the future.")
     end
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -b.average_rating }
    sorted_by_rating_in_desc_order.first(n)
  end

  def to_s
    "#{name}"
  end
end
