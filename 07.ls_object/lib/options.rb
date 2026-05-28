# frozen_string_literal: true

class Options
  def initialize(argv)
    flags = argv.select { |a| a.start_with?('-') }.join.delete('-')
    @all = flags.include?('a')
    @long = flags.include?('l')
    @reverse = flags.include?('r')
  end

  def all?
    @all
  end

  def long?
    @long
  end

  def reverse?
    @reverse
  end
end
