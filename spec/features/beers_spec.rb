require 'spec_helper'

describe "Beer" do
  include OwnTestHelper

  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:style){FactoryGirl.create :style, :name => "Pale ale"}

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "when added, is added to the brewery" do
    visit new_beer_path
    fill_in('beer[name]', :with => 'Ale 1')
    select(brewery.name, :from => 'beer[brewery_id]')
    select(style.name, :from => 'beer[style_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    expect(brewery.beers.count).to eq(1)
  end
end