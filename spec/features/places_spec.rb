require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [  Place.new(:name => "Oljenkorsi") ] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, they are shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [  Place.new(:name => "Oljenkorsi"),
                                                                   Place.new(:name => "Polvenkorsi"),
                                                                   Place.new(:name => "Toinen orsi")] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Polvenkorsi"
    expect(page).to have_content "Toinen orsi"
  end

  it "if none are returned by the API, an error is shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end
end