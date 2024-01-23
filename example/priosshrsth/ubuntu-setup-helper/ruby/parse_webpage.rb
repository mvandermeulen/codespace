URL = "#{ARGV[0]}"

QUERY = "[data-pjax='#repo-content-pjax-container'] .css-truncate"

require 'nokogiri'
require 'httparty'

page = HTTParty.get("#{URL}")

doc = Nokogiri::HTML(page.body)

VERSION = doc.css(QUERY).text

puts VERSION.gsub(/[^((0-9) | (.))]/, '')
