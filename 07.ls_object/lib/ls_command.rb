# frozen_string_literal: true

require_relative 'options'
require_relative 'file_entry'
require_relative 'formatter'

class Ls
  def initialize(argv)
    @argv = argv
  end

  def run
    parse_arguments
    build_entries
    filter_entries
    sort_entries
    output
  end

  private

  def parse_arguments
    @options = Options.new(@argv)
  end

  def build_entries
    @entries = Dir.entries('.').map { |name| FileEntry.new(name) }
  end

  def filter_entries
    @entries = @entries.reject(&:hidden?) unless @options.all?
  end

  def sort_entries
    @entries = @entries.sort_by(&:name)
    @entries = @entries.reverse if @options.reverse?
  end

  def output
    puts Formatter.new(@entries, @options).format
  end
end
