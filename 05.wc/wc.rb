# frozen_string_literal: true

require 'optparse'

params = {}
opt = OptionParser.new
opt.on('-l') { params[:lines] = true }
opt.on('-w') { params[:words] = true }
opt.on('-c') { params[:bytes] = true }
opt.parse!(ARGV)

keys = []
keys << :lines if params[:lines]
keys << :words if params[:words]
keys << :bytes if params[:bytes]
keys = %i[lines words bytes] if keys.empty?

def count_up(string, name)
  {
    lines: string.count("\n"),
    words: string.split.size,
    bytes: string.bytesize,
    name: name
  }
end

results =
  if ARGV.empty?
    [count_up($stdin.read, '')]
  else
    ARGV.map { |file_name| count_up(File.read(file_name), file_name) }
  end

width =
  if keys.size == 1 && results.size == 1
    1
  elsif ARGV.empty?
    7
  else
    results.sum { |result| result[:bytes] }.to_s.size
  end

results.each do |result|
  line = keys.map { |key| format("%#{width}d", result[key]) }.join(' ')
  line += " #{result[:name]}" unless result[:name].empty?
  puts line
end

if results.size > 1
  line = keys.map { |key| format("%#{width}d", results.sum { |result| result[key] }) }.join(' ')
  puts "#{line} total"
end
