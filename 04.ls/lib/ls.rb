# frozen_string_literal: true

COLUMN_COUNT = 3

def fetch_files
  Dir.glob('*').sort
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

files = fetch_files

unless files.empty?
  table = build_table(files, COLUMN_COUNT)
  print_table(table, files.map(&:size).max + 2)
end
