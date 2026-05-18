#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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

def collect_items(all: false, reverse: false)
  flag = all ? File::FNM_DOTMATCH : 0
  items = Dir.glob('*', flag)
  reverse ? items.reverse : items
end

def main
  oputions = {}
  OptionParser.new do |opt|
    opt.on('-a') { oputions[:all] = true }
    opt.on('-r') { oputions[:reverse] = true }
  end.parse!(ARGV)

  entries = collect_items(**oputions)
  display_grid(entries)
end

main
