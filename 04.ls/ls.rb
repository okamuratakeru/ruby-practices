#!/usr/bin/env ruby
# frozen_string_literal: true

COLS = 3

def display_grid(items)
  rows = items.size.ceildiv(COLS)

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
end

def main
  items = Dir.glob('*').sort
  display_grid(items)
end

main
