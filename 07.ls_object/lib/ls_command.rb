# frozen_string_literal: true

require_relative 'options'
require_relative 'file_entry'
require_relative 'display_target'
require_relative 'formatter'

class Ls
  def initialize(argv)
    @argv = argv
  end

  def run
    @options = Options.new(@argv)
    file_entries = Dir.entries('.').map { |name| FileEntry.new(name) }
    entries = DisplayTarget.new(file_entries, @options).to_a
    puts Formatter.new(entries, @options).format
  end
end
