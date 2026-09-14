# frozen_string_literal: true

class LongFormatter
  TIME_FORMAT = '%b %e %H:%M'

  def initialize(entries)
    @entries = entries
  end

  def render
    lines = @entries.map { |entry| format_line(entry) }
    [total_line, *lines].join("\n")
  end

  private

  def total_line
    "total #{@entries.sum(&:blocks) / 2}"
  end

  def format_line(entry)
    [
      entry.mode,
      entry.nlink.to_s.rjust(widths[:nlink]),
      entry.owner.ljust(widths[:owner]),
      entry.group.ljust(widths[:group]),
      entry.size.to_s.rjust(widths[:size]),
      entry.mtime.strftime(TIME_FORMAT),
      entry.name
    ].join(' ')
  end

  def widths
    @widths ||= {
      nlink: max_width(@entries.map(&:nlink)),
      owner: max_width(@entries.map(&:owner)),
      group: max_width(@entries.map(&:group)),
      size: max_width(@entries.map(&:size))
    }
  end

  def max_width(values)
    values.map { |value| value.to_s.size }.max
  end
end
