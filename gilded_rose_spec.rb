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
    expect(subject.items.any? {|i| i.quality < 0}).to eq(false)
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

  it "Once the sell by date has passed, Quality degrades twice as fast" do
    testable_items = subject.items.reject do |i| 
      ["Sulfuras", "Backstage", "Aged"].any? { |name| i.name.start_with? name }
    end
    11.times { subject.update_quality }
    testable_items.each do |i|
      if i.sell_in < 0
        q_before_update = i.quality
        subject.update_quality
        q_after_update = q_before_update-2 >= 0 ? q_before_update-2 : 0
        expect(i.quality).to be q_after_update
      end
    end
  end

  it "\"Backstage passes\", like aged brie, increases in Quality as it's SellIn value approaches; Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but Quality drops to 0 after the concert" do
    backstage_item = subject.items.select { |i| i.name.start_with? "Backstage" }.first
    prev = backstage_item.quality
    subject.update_quality
    increases_by_1 = backstage_item.quality == prev + 1

    4.times { subject.update_quality }
    prev_2 = backstage_item.quality
    subject.update_quality
    increases_by_2 = backstage_item.quality

    5.times { subject.update_quality }
    prev = backstage_item.quality
    subject.update_quality
    increases_by_3 = backstage_item.quality == prev + 3

    5.times { subject.update_quality }
    prev = backstage_item.quality
    subject.update_quality
    goes_to_zero = backstage_item.quality == 0

    expect(increases_by_1).to be true
    expect(increases_by_2).to be prev_2+2
    expect(increases_by_3).to be true
    expect(goes_to_zero).to be true
  end

  it "\"Conjured\" items degrade in Quality twice as fast as normal items" do
    conjured_items = subject.items.select { |i| i.name.start_with? "Conjured"}
    conjured_items.each do |i|
      prev_qual = i.quality
      subject.update_quality
      expect(i.quality).to eq(prev_qual-2)
    end
  end

  it "Sell ins do not decrease by more than 1 for every single item except \"Sulfuras\"" do 
    subject.items.each do |i|
      if i.name != "Sulfuras, Hand of Ragnaros"
        get_the_sellby_first = i.sell_in
        subject.update_quality
        expect(i.sell_in).to eq(get_the_sellby_first-1)
      end
    end
  end

end