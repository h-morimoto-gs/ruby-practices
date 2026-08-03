#!/usr/bin/env ruby

require "date"
require "optparse"

today = Date.today
year = today.year
month = today.month

opt = OptionParser.new
opt.on("-y YEAR", Integer) {|v| year = v}
opt.on("-m MONTH", Integer) {|v| month = v}
opt.parse!(ARGV)

first_date = Date.new(year, month, 1)
last_date  = Date.new(year, month, -1)

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_date.wday

(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2), " "
  puts "" if date.saturday?
end
puts "" unless last_date.saturday?

