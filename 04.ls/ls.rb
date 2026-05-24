#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLS = 3

TYPE_CHAR = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'socket' => 's',
  'unknown' => '?'
}.freeze

PERM_TABLE = {
  '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
  '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
}.freeze

def mode_string(stat)
  type  = TYPE_CHAR[stat.ftype]
  octal = format('%03o', stat.mode & 0o777)
  perms = octal.chars.map { |digit| PERM_TABLE[digit] }.join
  type + perms
end

def max_width(entries, attribute)
  entries.map { |e| e[attribute].length }.max
end

def print_grid(items)
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

def column_widths(entries)
  {
    nlink: max_width(entries, :nlink),
    owner: max_width(entries, :owner),
    group: max_width(entries, :group),
    size: max_width(entries, :size)
  }
end

def build_entries(file_list)
  file_list.map do |file|
    status = File.lstat(file)
    {
      mode: mode_string(status),
      nlink: status.nlink.to_s,
      owner: Etc.getpwuid(status.uid).name,
      group: Etc.getgrgid(status.gid).name,
      size: status.size.to_s,
      mtime: status.mtime.strftime('%b %e %H:%M'),
      name: File.basename(file),
      blocks: status.blocks
    }
  end
end

def print_long(file_list)
  entries = build_entries(file_list)

  puts "total #{entries.sum { |e| e[:blocks] }}"

  widths = column_widths(entries)

  entries.each do |e|
    puts [
      e[:mode],
      e[:nlink].rjust(widths[:nlink]),
      e[:owner].ljust(widths[:owner]),
      e[:group].ljust(widths[:group]),
      e[:size].rjust(widths[:size]),
      e[:mtime],
      e[:name]
    ].join(' ')
  end
end

def filter_entries(all: false, reverse: false)
  flag = all ? File::FNM_DOTMATCH : 0
  items = Dir.glob('*', flag)
  reverse ? items.reverse : items
end

def main
  options = {}
  OptionParser.new do |opt|
    opt.on('-a') { options[:all] = true }
    opt.on('-r') { options[:reverse] = true }
    opt.on('-l') { options[:long] = true }
  end.parse!(ARGV)

  file_list = filter_entries(all: options[:all], reverse: options[:reverse])

  if options[:long]
    print_long(file_list)
  else
    print_grid(file_list)
  end
end

main
