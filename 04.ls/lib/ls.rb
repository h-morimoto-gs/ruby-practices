# frozen_string_literal: true

require 'etc'
require 'optparse'

COLUMN_COUNT = 3

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

def parse_options
  options = { all: false, reverse: false, long: false }
  OptionParser.new do |opt|
    opt.on('-a') { options[:all] = true }
    opt.on('-r') { options[:reverse] = true }
    opt.on('-l') { options[:long] = true }
  end.parse!(ARGV)
  options
end

def fetch_and_sort_files(show_all:, reverse:)
  flags = show_all ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).sort
  reverse ? files.reverse : files
end

def format_mode(stat)
  file_type = if stat.symlink?
                'l'
              elsif stat.directory?
                'd'
              else
                '-'
              end
  permissions = stat.mode.to_s(8)[-3..].chars.map { |n| PERM_MAP[n] }.join
  file_type + permissions
end

def build_file_rows(files)
  files.map do |file|
    stat = File.lstat(file)
    {
      mode: format_mode(stat),
      nlink: stat.nlink.to_s,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size.to_s,
      time: stat.mtime.strftime('%b %e %H:%M'),
      name: file,
      blocks: stat.blocks
    }
  end
end

def calculate_widths(rows)
  %i[nlink owner group size].to_h do |key|
    [key, rows.map { |row| row[key].size }.max]
  end
end

def format_file_line(row, widths)
  [
    row[:mode],
    row[:nlink].rjust(widths[:nlink]),
    row[:owner].ljust(widths[:owner]),
    row[:group].ljust(widths[:group]),
    row[:size].rjust(widths[:size]),
    row[:time],
    row[:name]
  ].join(' ')
end

def print_long_format(files)
  rows = build_file_rows(files)
  widths = calculate_widths(rows)
  puts "total #{rows.sum { |row| row[:blocks] } / 2}"
  rows.each { |row| puts format_file_line(row, widths) }
end

def build_table(files, column_count)
  rows = (files.size / column_count.to_f).ceil
  columns = files.each_slice(rows).to_a
  columns.map { |col| col.values_at(0...rows) }.transpose
end

def print_table(files, column_count)
  table = build_table(files, column_count)
  width = files.map(&:size).max + 2
  table.each do |row|
    puts row.map { |file| file.to_s.ljust(width) }.join.rstrip
  end
end

options = parse_options
files = fetch_and_sort_files(show_all: options[:all], reverse: options[:reverse])

unless files.empty?
  if options[:long]
    print_long_format(files)
  else
    print_table(files, COLUMN_COUNT)
  end
end
