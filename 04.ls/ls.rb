#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLS = 3

command = ARGV[0].delete('-') # -aの-を削除してaだけにする

# コマンドが複数あれば、for文で回す
items = case command
        when 'a'
          Dir.glob('*', File::FNM_DOTMATCH).sort
        else
          Dir.glob('*').sort
        end

def print_items(items)
  # 3列で表示するための行数を計算
  rows = (items.size.to_f / COLS).ceil

  # アイテムを行列に配置
  grid = Array.new(rows) { Array.new(COLS) }
  items.each_with_index do |name, i|
    row = i % rows
    col = i / rows
    grid[row][col] = name
  end

  # 列の幅を計算
  width = items.map(&:length).max + 2

  # 行列を表示
  grid.each do |row|
    row.each { |name| printf "%-#{width}s", (name || '') }
    puts
  end
end

print_items(items)
