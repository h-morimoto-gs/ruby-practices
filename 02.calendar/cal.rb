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

last_date = Date.new(year, month, -1)
days_in_month = last_date.day
first_wday = Date.new(year, month, 1).wday

puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
print "   " * first_wday

(1..days_in_month).each do |day|
  date = Date.new(year, month, day)

  print day.to_s.rjust(2), " "
  puts "" if date.saturday?
end
puts "" unless last_date.saturday?

