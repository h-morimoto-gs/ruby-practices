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

def count_text(text, name)
  {
    lines: text.count("\n"),
    words: text.split.size,
    bytes: text.bytesize,
    name: name
  }
end

counts =
  if ARGV.empty?
    [count_text($stdin.read, '')]
  else
    ARGV.map { |file_name| count_text(File.read(file_name), file_name) }
  end

width =
  if keys.size == 1 && counts.size == 1
    1
  elsif ARGV.empty?
    7
  else
    counts.sum { |count| count[:bytes] }.to_s.size
  end

counts.each do |count|
  line = keys.map { |key| format("%#{width}d", count[key]) }.join(' ')
  line += " #{count[:name]}" unless count[:name].empty?
  puts line
end

if counts.size > 1
  line = keys.map { |key| format("%#{width}d", counts.sum { |count| count[key] }) }.join(' ')
  puts "#{line} total"
end
