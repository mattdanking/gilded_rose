require './gilded_rose.rb'
require "rspec"

describe GildedRose do

  it "should do something" do
    subject.update_quality
  end

  it "\"Sulfuras\", being a legendary item, never has to be sold or decreases in Quality" do
    subject.items.each do |i|
      if i.name == "Sulfuras, Hand of Ragnaros"
        sulfuras = i.quality
        subject.update_quality
        expect(i.quality).to eq(sulfuras)
      end
    end
  end

end