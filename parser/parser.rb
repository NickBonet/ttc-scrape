require 'open-uri'
require 'uri'
require 'nokogiri'
require 'rufus-lua'
require 'json'
require 'pry'
require_relative 'listing'

class Parser
  @@default_region = "us"
  @@base_url = "https://#{@@default_region}.tamrieltradecentre.com/pc/Trade/SearchResult"
  @@lua = Rufus::Lua::State.new 

  def self.parse_listings(url)
    doc = Nokogiri::HTML(URI.open(url))
    page_results = doc.xpath('//tr[@class="cursor-pointer"]')
    listings = []
    for i in page_results
      item_name = i.xpath('.//td[1]/div[1]/text()').text.strip
      price_info_arr = i.xpath('.//td[4]/text()').text.strip.gsub(/\s+/, "/").split("/")
      price_per = price_info_arr[0]
      quantity = price_info_arr[1]
      total_price = price_info_arr[2]
      last_seen = i.xpath('.//td[5]/@data-mins-elapsed').first.value
      location = i.xpath('.//td[3]/div[1]/text()').text.strip + " @ " + i.xpath('.//td[3]/div[2]/text()').text.strip
      listing = Listing.new(item_name, price_per, quantity, total_price, last_seen, location)
      listings.append listing
    end
    listings
  end

  def self.make_url(item_id)
    new_url = URI(@@base_url)
    params = {ItemID: item_id, SortBy: "LastSeen", Order: "desc"}
    new_url.query = URI.encode_www_form(params)
    new_url
  end

  def self.parse_item_table
    @@lua.eval("TamrielTradeCentre = {}")
    @@lua.eval(IO.read('ItemLookUpTable_EN.lua'))
    @@lua.eval("TamrielTradeCentre:LoadItemLookUpTable()")
    lua_items = @@lua.eval('return TamrielTradeCentre.ItemLookUpTable')
  end
end

Parser.parse_item_table