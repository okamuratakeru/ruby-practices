# frozen_string_literal: true

require 'etc'

class FileEntry
  TYPE_CHAR = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'socket' => 's',
    'unknown' => '?'
  }.freeze

  PERM_TABLE = {
    '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
    '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
  }.freeze

  attr_reader :name, :permission, :nlink, :owner, :group, :size, :mtime, :blocks

  def initialize(name)
    @name = name
    stat = File.lstat(name)
    @permission = build_permission(stat)
    @nlink = stat.nlink
    @owner = Etc.getpwuid(stat.uid).name
    @group = Etc.getgrgid(stat.gid).name
    @size = stat.size
    @mtime = stat.mtime
    @blocks = stat.blocks
  end

  def hidden?
    @name.start_with?('.')
  end

  private

  def build_permission(stat)
    type = TYPE_CHAR[stat.ftype]
    octal = format('%03o', stat.mode & 0o777)
    perms = octal.chars.map { |digit| PERM_TABLE[digit] }.join
    type + perms
  end
end
