class Listing
  @item_name = ""
  @price_per = 0
  @quantity = 0
  @total_price = 0
  @last_seen = 0
  @location = ""

  def initialize(name, price_per, quantity, total, last_seen, location)
    @item_name = name
    @price_per = price_per
    @quantity = quantity
    @total_price = total
    @last_seen = last_seen
    @location = location
  end

  def to_s
    "Item: #{@item_name} / Price per: #{@price_per} / Quantity: #{@quantity} / Total Price: #{@total_price} / Location: #{@location} / Last Seen: #{@last_seen} minute(s) ago"
  end
end