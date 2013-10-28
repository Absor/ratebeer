require 'spec_helper'

describe Beer do
  it 'is not created without a name' do
    style = Style.create :name => "Lager"
    beer = Beer.create :name => nil, :style => style

    expect(beer.valid?).to be false
    expect(Beer.count).to be 0
  end

  it 'is not created without a style' do
    beer = Beer.create :name => "Iso 1", :style => nil

    expect(beer.valid?).to be false
    expect(Beer.count).to be 0
  end
end
