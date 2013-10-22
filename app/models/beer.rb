class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings, :dependent => :destroy

  def average_rating
    sum = ratings.inject(0) { |result, element| result + element.score}
    sum / ratings.count
  end

  def to_s
    "#{name} - #{brewery.name}"
  end
end
