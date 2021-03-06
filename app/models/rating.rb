class Rating < ActiveRecord::Base

  validates_numericality_of :score, { :greater_than_or_equal_to => 1,
                                      :less_than_or_equal_to => 50,
                                      :only_integer => true }

  belongs_to :beer
  belongs_to :user

  scope :recent, ->(n) { order(created_at: :desc).limit(n) }

  def to_s
    "#{beer.name} #{score}"
  end
end
