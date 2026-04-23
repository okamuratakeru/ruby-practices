#!/usr/bin/env ruby

COLS = 3

items = Dir.glob('*').sort
rows = (items.size.to_f / COLS).ceil

grid = Array.new(rows) { Array.new(COLS) }
items.each_with_index do |name, i|
  row = i % rows
  col = i / rows
  grid[row][col] = name
end

width = items.map(&:length).max + 2

grid.each do |row|
  row.each { |name| printf "%-#{width}s", (name || '') }
  puts
end
