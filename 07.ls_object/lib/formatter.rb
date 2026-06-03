# frozen_string_literal: true

class Formatter
  COLUMN_COUNT = 2
  COLUMN_SPACING = '  '

  def initialize(files, options)
    @files = files
    @options = options
  end

  def format
    if @options.long?
      long_format
    else
      short_format
    end
  end

  private

  def short_format
    return '' if @files.empty?

    names = @files.map(&:name)
    rows = names.size.ceildiv(COLUMN_COUNT)
    padded_columns = build_padded_columns(names, rows)
    padded_columns.transpose.map { |row| format_short_row(row) }.join("\n")
  end

  def build_padded_columns(names, rows)
    columns = names.each_slice(rows).to_a
    @column_max_widths = columns.map { |col| col.map(&:length).max }
    columns.map { |col| col + [nil] * (rows - col.length) }
  end

  def format_short_row(row)
    row.each_with_index.map do |name, i|
      name ? name.ljust(@column_max_widths[i]) : ''
    end.join(COLUMN_SPACING).rstrip
  end

  def long_format
    total = "total #{@files.map(&:blocks).sum}"
    widths = column_widths
    lines = @files.map { |file| format_long_line(file, widths) }
    ([total] + lines).join("\n")
  end

  def column_widths
    {
      nlink: max_length(&:nlink),
      owner: max_length(&:owner),
      group: max_length(&:group),
      size: max_length(&:size)
    }
  end

  def max_length(&block)
    @files.map(&block).map(&:to_s).map(&:length).max || 0
  end

  def format_long_line(file, widths)
    [
      file.permission,
      file.nlink.to_s.rjust(widths[:nlink]),
      file.owner.ljust(widths[:owner]),
      file.group.ljust(widths[:group]),
      file.size.to_s.rjust(widths[:size]),
      file.mtime.strftime('%b %e %H:%M'),
      file.name
    ].join(' ')
  end
end
