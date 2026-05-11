#!/usr/bin/env ruby
# frozen_string_literal: true

COLS = 3

def display_grid(items)
  return if items.empty?

  rows = items.size.ceildiv(COLS)

  grid = Array.new(rows) { Array.new(COLS) }
  items.each_with_index do |name, i|
    col, row = i.divmod(rows)
    grid[row][col] = name
  end

  width = items.map(&:length).max + 2

  grid.each do |row|
    row.each { |name| print name.to_s.ljust(width) }
    puts
  end
end

def main
  return unless ARGV.include?('-a')

  items = Dir.glob("*", File::FNM_DOTMATCH)
  display_grid(items)
end

main
