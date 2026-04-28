#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLS = 3

def print_items(items)
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
end

def main
  command = ARGV[0].delete('-')

  items = command

  print_items(items)
end

main
