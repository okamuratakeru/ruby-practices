#!/usr/bin/env ruby
# frozen_string_literal: true

exit unless ARGV.include?('-l')

require 'etc'

TYPE_CHAR = {
  'file' => '-', 'directory' => 'd', 'link' => 'l',
  'characterSpecial' => 'c', 'blockSpecial' => 'b',
  'fifo' => 'p', 'socket' => 's', 'unknown' => '?'
}.freeze

PERM_TABLE = {
  '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
  '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
}.freeze

def mode_string(stat)
  type = TYPE_CHAR[stat.ftype]
  octal = format('%03o', stat.mode & 0o777)
  perms = octal.chars.map { |digit| PERM_TABLE[digit] }.join

  type + perms
end

def max_width(entries, &block)
  entries.map(&block).map { |v| v.to_s.length }.max
end

items = Dir.glob('*')

entries = items.map do |name|
  stat = File.lstat(name)
  {
    mode: mode_string(stat),
    nlink: stat.nlink,
    user: Etc.getpwuid(stat.uid).name,
    group: Etc.getgrgid(stat.gid).name,
    size: stat.size,
    mtime: stat.mtime.strftime('%b %e %H:%M'),
    name: File.basename(name),
    blocks: stat.blocks
  }
end

nlink_w = max_width(entries) { |e| e[:nlink] }
user_w  = max_width(entries) { |e| e[:user] }
group_w = max_width(entries) { |e| e[:group] }
size_w  = max_width(entries) { |e| e[:size] }

puts "total #{entries.sum { |e| e[:blocks] }}"

entries.each do |e|
  printf "%s %*d %-*s  %-*s %*d %s %s\n",
         e[:mode],
         nlink_w, e[:nlink],
         user_w,  e[:user],
         group_w, e[:group],
         size_w,  e[:size],
         e[:mtime],
         e[:name]
end
