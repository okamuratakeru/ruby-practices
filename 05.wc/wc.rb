#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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

def calc_totals(file_stats, options)
  [
    options[:lines] ? file_stats.sum { |e| e[:stats][0] } : nil,
    options[:words] ? file_stats.sum { |e| e[:stats][1] } : nil,
    options[:bytes] ? file_stats.sum { |e| e[:stats][2] } : nil
  ]
end

def print_stats(file_stats, options)
  file_stats.each do |entry|
    puts format_line(*entry[:stats], File.basename(entry[:path]))
  end

  return unless file_stats.size > 1

  puts format_line(*calc_totals(file_stats, options), 'total')
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

def get_file_path(file_name)
  current_dir = Dir.pwd
  file_path = File.join(current_dir, file_name)
  abort "wc: #{file_name}: No such file or directory" unless File.exist?(file_path)

  file_path
end

def main
  options = parse_options

  if !$stdin.tty? && ARGV.empty?
    text = $stdin.read
    puts format_line(*count_text(text, options), '')
  else
    file_stats = ARGV.map { |name| get_file_path(name) }
                     .map { |path| { path: path, stats: count_text(File.read(path), options) } }
    print_stats(file_stats, options)
  end
end

main
