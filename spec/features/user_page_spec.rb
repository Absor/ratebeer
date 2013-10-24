require 'spec_helper'

describe "User's page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery1) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:brewery2) { FactoryGirl.create :brewery, :name => "Toinen" }
  let!(:beer1) { FactoryGirl.create :beer, :style => "Pale ale", :brewery => brewery1 }
  let!(:beer2) { FactoryGirl.create :beer, :style => "Lager", :brewery => brewery2 }

  it "has no information about favorite beer style or brewery without ratings" do
    visit user_path(user.id)
    expect(page).to_not have_content "Favorite beer style"
    expect(page).to_not have_content "favorite brewery"
  end

  it "has information about favorite beer style and brewery with ratings" do
    FactoryGirl.create :rating, :beer => beer1, :score => 2, :user => user
    FactoryGirl.create :rating, :beer => beer2, :score => 1, :user => user

    visit user_path(user.id)
    expect(page).to have_content "Favorite beer style is Pale ale"
    expect(page).to have_content "favorite brewery is Koff"
  end
end
