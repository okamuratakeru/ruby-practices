# frozen_string_literal: true

require_relative 'options'
require_relative 'file_entry'
require_relative 'file_list'
require_relative 'formatter'

class LsCommand
  def initialize(argv)
    @argv = argv
  end

  def run
    @options = Options.new(@argv)
    file_entries = Dir.entries('.').map { |name| FileEntry.new(name) }
    entries = FileList.new(file_entries, @options).to_a
    puts Formatter.new(entries, @options).format
  end
end
