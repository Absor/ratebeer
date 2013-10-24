require 'spec_helper'

describe "Rating" do
  include OwnTestHelper

  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  describe "when given" do

    before :each do
      visit new_rating_path
      select(beer1.to_s, :from => 'rating[beer_id]')
      fill_in('rating[score]', :with => '15')
      expect{
        click_button "Create Rating"
      }.to change{Rating.count}.from(0).to(1)
    end

    it "is registered to the beer and user who is signed in" do
      expect(user.ratings.count).to eq(1)
      expect(beer1.ratings.count).to eq(1)
      expect(beer1.average_rating).to eq(15.0)
    end

    it "is listed on the ratings page" do
      visit ratings_path
      expect(page).to have_content beer1.ratings.first
    end

    it "is listed on the users page" do
       visit user_path(user.id)
       expect(page).to have_content beer1.ratings.first
    end

    it "and removed, is deleted from database" do
      visit user_path(user.id)
      click_link "delete"

      expect(user.ratings.count).to eq(0)
      expect(beer1.ratings.count).to eq(0)
    end
  end
end