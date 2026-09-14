# frozen_string_literal: true

require 'etc'

class FileEntry
  PERM_MAP = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :name

  def initialize(name)
    @name = name
    @stat = File.lstat(name)
  end

  def mode
    file_type + permissions
  end

  def nlink
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end

  def blocks
    @stat.blocks
  end

  private

  def file_type
    if @stat.symlink?
      'l'
    elsif @stat.directory?
      'd'
    else
      '-'
    end
  end

  def permissions
    @stat.mode.to_s(8)[-3..].chars.map { |n| PERM_MAP[n] }.join
  end
end
