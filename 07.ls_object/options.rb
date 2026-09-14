# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @options = parse(argv)
  end

  def all?
    @options[:all]
  end

  def reverse?
    @options[:reverse]
  end

  def long?
    @options[:long]
  end

  private

  def parse(argv)
    options = { all: false, reverse: false, long: false }
    OptionParser.new do |opt|
      opt.on('-a') { options[:all] = true }
      opt.on('-r') { options[:reverse] = true }
      opt.on('-l') { options[:long] = true }
    end.parse!(argv)
    options
  end
end
