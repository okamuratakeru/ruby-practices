#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def get_file_path(file_name)
  current_dir = Dir.pwd
  file_path = File.join(current_dir, file_name)
  abort "wc: #{file_name}: No such file or directory" unless File.exist?(file_path)

  file_path
end

def count_text(text, options)
  [
    options[:lines] ? text.count("\n") : nil,
    options[:words] ? text.split.size : nil,
    options[:bytes] ? text.bytesize : nil
  ]
end

def format_line(lines, words, bytes, label)
  counts = [lines, words, bytes].compact.map { |n| format('%<n>8d', n:) }.join
  label.empty? ? counts : "#{counts} #{label}"
end

def print_stats(file_paths, stats, options)
  file_paths.each_with_index do |path, i|
    puts format_line(*stats[i], File.basename(path))
  end
  print_total_stats(stats, options) if file_paths.size > 1
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

def main
  options = parse_options

  if !$stdin.tty? && ARGV.empty?
    text = $stdin.read
    puts format_line(*count_text(text, options), '')
  else
    file_paths = ARGV.map { |name| get_file_path(name) }
    stats = file_paths.map { |path| count_text(File.read(path), options) }
    print_stats(file_paths, stats, options)
  end
end

main
