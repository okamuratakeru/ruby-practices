# frozen_string_literal: true

class Options
  def initialize(argv)
    @flags = argv.select { |a| a.start_with?('-') }.join.delete('-')
  end

  def all?
    @flags.include?('a')
  end

  def long?
    @flags.include?('l')
  end

  def reverse?
    @flags.include?('r')
  end
end
