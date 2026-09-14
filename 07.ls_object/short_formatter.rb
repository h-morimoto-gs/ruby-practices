# frozen_string_literal: true

class ShortFormatter
  COLUMN_COUNT = 3

  def initialize(entries)
    @entries = entries
  end

  def render
    names = @entries.map(&:name)
    width = names.map(&:size).max + 2
    table = build_table(names)
    table.map { |row| row.map { |name| name.to_s.ljust(width) }.join.rstrip }.join("\n")
  end

  private

  def build_table(names)
    row_count = (names.size / COLUMN_COUNT.to_f).ceil
    columns = names.each_slice(row_count).to_a
    columns.map { |column| column.values_at(0...row_count) }.transpose
  end
end
