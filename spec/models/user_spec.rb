require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new :username => "Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a proper password" do
    user = User.create :username => "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new :score => 10
      rating2 = Rating.new :score => 20

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved with a short password" do
    user = User.create :username => "Pekka", :password => "te1", :password_confirmation => "te1"

    expect(user.valid?).to be false
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting of only letters" do
    user = User.create :username => "Pekka", :password => "testitesti", :password_confirmation => "testitesti"

    expect(user.valid?).to be false
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beers_with_ratings 10, 20, 15, 7, 9, user
      best = create_beer_with_rating 25, user

      expect(user.favorite_beer).to eq(best)
    end

    def create_beers_with_ratings(*scores, user)
      scores.each do |score|
        create_beer_with_rating score, user
      end
    end

    def create_beer_with_rating(score,  user)
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
      beer
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user, "Style1"

      expect(user.favorite_style.name).to eq("Style1")
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_ratings 10, 20, user, "Style1" # 15.0 average
      create_beers_with_ratings 20, 30, user, "Style2" # 25.0 average
      best = create_beer_with_rating 20, user, "Style3" # 20.0 average

      expect(user.favorite_style.name).to eq("Style2")
    end

    def create_beers_with_ratings(*scores, user, style)
      scores.each do |score|
        create_beer_with_rating score, user, style
      end
    end

    def create_beer_with_rating(score,  user, style)
      sty = FactoryGirl.create(:style, :name => style)
      beer = FactoryGirl.create(:beer, :style => sty)
      FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
      beer
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user, "Brewery1"

      expect(user.favorite_brewery).to eq("Brewery1")
    end

    it "is the one with the highest average rating if several rated" do
      create_beers_with_ratings 10, 20, user, "Brewery1" # 15.0 average
      create_beers_with_ratings 20, 30, user, "Brewery2" # 25.0 average
      best = create_beer_with_rating 20, user, "Brewery3" # 20.0 average

      expect(user.favorite_brewery).to eq("Brewery2")
    end

    def create_beers_with_ratings(*scores, user, brewery_name)
      scores.each do |score|
        create_beer_with_rating score, user, brewery_name
      end
    end

    def create_beer_with_rating(score,  user, brewery_name)
      brewery = FactoryGirl.create(:brewery, :name => brewery_name)
      beer = FactoryGirl.create(:beer, :brewery => brewery)
      FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
      beer
    end
  end
end
