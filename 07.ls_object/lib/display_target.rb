# frozen_string_literal: true

class DisplayTarget
  def initialize(entries, options)
    @entries = entries
    @options = options
  end

  def to_a
    filter(sort(@entries))
  end

  private

  def filter(entries)
    @options.all? ? entries : entries.reject(&:hidden?)
  end

  def sort(entries)
    result = entries.sort_by(&:name)
    @options.reverse? ? result.reverse : result
  end
end
