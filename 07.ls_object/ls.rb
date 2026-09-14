# frozen_string_literal: true

require_relative 'options'
require_relative 'file_collection'
require_relative 'short_formatter'
require_relative 'long_formatter'

options = Options.new(ARGV)
collection = FileCollection.new(show_all: options.all?, reverse: options.reverse?)

unless collection.empty?
  formatter_class = options.long? ? LongFormatter : ShortFormatter
  puts formatter_class.new(collection.entries).render
end
