require './item.rb'

class GildedRose
  attr_accessor :items # so we have access to items outside of GildedRose

  @items = []

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def update_normal_item(item_index)
    @items[item_index].sell_in = @items[item_index].sell_in - 1

    if @items[item_index].quality > 0
      @items[item_index].quality = @items[item_index].quality - 1
      if @items[item_index].sell_in < 0 && @items[item_index].quality > 0
        @items[item_index].quality = @items[item_index].quality - 1
      end
    end
  end

  def update_sulfuras(i)
  end

  def update_conjured(i)
    update_normal_item(i)
    update_normal_item(i)
    @items[i].sell_in += 1
  end

  def update_aged_brie(item_index)
    @items[item_index].sell_in = @items[item_index].sell_in - 1

    if @items[item_index].quality < 50
      @items[item_index].quality = @items[item_index].quality + 1
    end
  end

  def update_backstage_passes(item_index)
    @items[item_index].sell_in = @items[item_index].sell_in - 1
    @items[item_index].quality = @items[item_index].quality + 1
    if (@items[item_index].quality < 50)
      if (@items[item_index].sell_in < 11)
        @items[item_index].quality = @items[item_index].quality + 1
      end
      if (@items[item_index].sell_in < 6)
        @items[item_index].quality = @items[item_index].quality + 1
      end
    end

    if (@items[item_index].sell_in < 0)
      @items[item_index].quality = @items[item_index].quality - @items[item_index].quality
    end
  end

  def update_quality

    for i in 0..(@items.size-1)
      case @items[i].name
      when "Aged Brie"
        update_aged_brie(i)
      when "Sulfuras, Hand of Ragnaros"
        update_sulfuras(i)
      when "Backstage passes to a TAFKAL80ETC concert"
        update_backstage_passes(i)
      when "Conjured Mana Cake"
        update_conjured(i)
      else
        update_normal_item(i)
      end


      if (@items[i].name != "Aged Brie" && @items[i].name != "Backstage passes to a TAFKAL80ETC concert")
        if (@items[i].quality > 0)
          if (@items[i].name != "Sulfuras, Hand of Ragnaros")
            update_normal_item(i)
          end
        end
      else
        if (@items[i].quality < 50)
          @items[i].quality = @items[i].quality + 1
          if (@items[i].name == "Backstage passes to a TAFKAL80ETC concert")
            if (@items[i].sell_in < 11)
              if (@items[i].quality < 50)
                @items[i].quality = @items[i].quality + 1
              end
            end
            if (@items[i].sell_in < 6)
              if (@items[i].quality < 50)
                @items[i].quality = @items[i].quality + 1
              end
            end
          end
        end
      end
      if (@items[i].sell_in < 0)
        if (@items[i].name != "Aged Brie")
          if (@items[i].name != "Backstage passes to a TAFKAL80ETC concert")
            "lool"
          else
            @items[i].quality = @items[i].quality - @items[i].quality
          end
        else
          update_aged_brie(i)
        end
      end
    end
  end

end