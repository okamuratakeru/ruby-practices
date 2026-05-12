#!/usr/bin/env ruby
# frozen_string_literal: true

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

title = "#{params[:year]}年 #{params[:month]}月"
title_width = 4 + 2 + params[:month].to_s.length + 2
puts ' ' * ((20 - title_width) / 2) + title
puts '日 月 火 水 木 金 土'
print '   ' * first.wday # 1日の曜日までスペース埋め
(1..last.day).each do |i|
  print "#{i.to_s.rjust(2)} "
  puts "\n" if ((first.wday + i) % 7).zero?
end
puts
