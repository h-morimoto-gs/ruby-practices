# frozen_string_literal: true

require_relative 'file_entry'

class FileCollection
  def initialize(show_all:, reverse:)
    @show_all = show_all
    @reverse = reverse
  end

  def entries
    @entries ||= build_entries
  end

  def empty?
    entries.empty?
  end

  private

  def build_entries
    flags = @show_all ? File::FNM_DOTMATCH : 0
    names = Dir.glob('*', flags).sort
    names.reverse! if @reverse
    names.map { |name| FileEntry.new(name) }
  end
end
