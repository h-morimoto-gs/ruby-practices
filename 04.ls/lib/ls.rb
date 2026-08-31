# frozen_string_literal: true

COLUMN_COUNT = 3

def fetch_files(show_all:, reverse:)
  flags = show_all ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).sort
  reverse ? files.reverse : files
end

def build_table(files, column_count)
  rows = (files.size / column_count.to_f).ceil
  columns = files.each_slice(rows).to_a
  columns.map { |col| col.values_at(0...rows) }.transpose
end

def print_table(table, width)
  table.each do |row|
    puts row.map { |file| file.to_s.ljust(width) }.join.rstrip
  end
end

show_all = ARGV.include?('-a')
reverse = ARGV.include?('-r')
files = fetch_files(show_all:, reverse:)

unless files.empty?
  table = build_table(files, COLUMN_COUNT)
  print_table(table, files.map(&:size).max + 2)
end
