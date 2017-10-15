require 'nokogiri'
require 'open-uri'
require_relative 'collection'

source_url = "http://gss.uva.nl/binaries/content/assets/programmas/information-studies/txt-for-assignment-data-science.txt?3015083536432"

doc = Nokogiri::HTML(open(source_url))

doc.search('text').each_with_index do |link, index|
  puts "TEXT #{index + 1}"
  puts link.content
end
