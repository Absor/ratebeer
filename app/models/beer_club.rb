class BeerClub < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user

  def unconfirmed_memberships
    memberships.where(confirmed: [nil, false])
  end

  def confirmed_memberships
    memberships.where(confirmed: true)
  end

  def confirmed_member?(user)
    users = confirmed_memberships.map{|ms| ms.user}
    users.include? user
  end
end
