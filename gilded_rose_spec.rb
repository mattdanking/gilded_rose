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

  it "The Quality of an item is never negative" do
    subject.update_quality
    expect(subject.items.any? { |i| i.quality < 0 }).to eq(false)
  end

  it "\"Aged Brie\" actually increases in Quality the older it gets" do
    subject.items.each do |i|
      if i.name == "Aged Brie"
        aged_brie = i.quality
        subject.update_quality
        expect(i.quality).to be > aged_brie
      end
    end    
  end

  it "The Quality of an item is never more than 50" do
    50.times do
      subject.update_quality
    end
    
    subject.items.each do |i|
      unless i.name == "Sulfuras, Hand of Ragnaros"
        expect(i.quality).to be <= 50
      end
    end    
  end

end