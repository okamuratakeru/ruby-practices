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

def main
  params = {}
  OptionParser.new do |opt|
    opt.on('-a') { params[:all] = true }
  end.parse!(ARGV)

  flag = params[:all] ? File::FNM_DOTMATCH : 0
  items = Dir.glob('*', flag)
  display_grid(items)
end

main
