#!/usr/bin/env ruby
require 'date'
require 'optparse'

today = Date.today
params = { year: today.year, month: today.month }

OptionParser.new do |opt|
  opt.on('-y YEAR',  Integer) { |v| params[:year]  = v }
  opt.on('-m MONTH', Integer) { |v| params[:month] = v }
  opt.parse!(ARGV)
end


first = Date.new(params[:year], params[:month], 1)
last  = Date.new(params[:year], params[:month], -1)

puts '日 月 火 水 木 金 土'
print '   ' * first.wday  # 1日の曜日までスペース埋め
(1..last.day).each do |i|
  print i.to_s.rjust(3)
  if (first.wday + i) % 7 == 0
    puts
  end
end
puts
