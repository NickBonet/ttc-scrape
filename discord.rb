require 'discordrb'
require 'dotenv'
require_relative 'parser/parser'

Dotenv.load('bot.env')

bot = Discordrb::Commands::CommandBot.new token: ENV["BOT_TOKEN"], prefix: '!'

bot.command :recent do |event, item_id|
  listings = Parser.parse_listings(Parser.make_url(item_id))
  event.channel.send_embed do |embed|
    listings.each_with_index do |listing, index|
      embed.add_field(name: "Listing #{index}:", value: listing.to_s)
    end
  end
end

bot.run