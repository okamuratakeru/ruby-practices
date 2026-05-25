#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def get_file_path(file_name)
  current_dir = Dir.pwd
  file_path = File.join(current_dir, file_name)
  abort "wc: #{file_name}: No such file or directory" unless File.exist?(file_path)

  file_path
end

def get_line_count(file_path)
  File.read(file_path).count("\n")
end

def get_word_count(file_path)
  File.read(file_path).split.size
end

def get_byte_count(file_path)
  File.size(file_path)
end

def format_line(lines, words, bytes, label)
  counts = [lines, words, bytes].compact.map { |n| format('%<n>8d', n:) }.join
  "#{counts} #{label}"
end

def print_file_stats(file_paths, stats)
  file_paths.each_with_index do |path, i|
    lines, words, bytes = stats[i]
    puts format_line(lines, words, bytes, File.basename(path))
  end
end

def print_total_stats(stats, options)
  total_lines = stats.sum { |s| s[0] } if options[:lines]
  total_words = stats.sum { |s| s[1] } if options[:words]
  total_bytes = stats.sum { |s| s[2] } if options[:bytes]
  puts format_line(total_lines, total_words, total_bytes, 'total')
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-l') { options[:lines] = true }
    opt.on('-w') { options[:words] = true }
    opt.on('-c') { options[:bytes] = true }
  end.parse!(ARGV)
  options.empty? ? { lines: true, words: true, bytes: true } : options
end

def parse_file_names
  return $stdin.readlines.reject { |line| line.split.first == 'total' }.map { |line| line.split[-1] }.compact unless $stdin.tty?

  ARGV
end

def build_stats(file_paths, options)
  file_paths.map do |path|
    [
      options[:lines] ? get_line_count(path) : nil,
      options[:words] ? get_word_count(path) : nil,
      options[:bytes] ? get_byte_count(path) : nil
    ]
  end
end

def main
  options = parse_options
  file_paths = parse_file_names.map { |name| get_file_path(name) }
  stats = build_stats(file_paths, options)

  print_file_stats(file_paths, stats)
  print_total_stats(stats, options) if file_paths.size >= 2
end

main
