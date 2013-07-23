#!/usr/bin/env ruby
require 'csv'
require 'nokogiri'
require 'benchmark'

$debug = false

$xpath_count = 0
$file_count = 0
timer = 
csv_file = "/Users/ryana/Projects/AuthoringTool/ScormAnalysis/html-files-content-development-dle.csv"
$fileRoot = "/Users/ryana/downloaded-moodlefiles"
file_hash = "a6deac9f5e6e9b17c1dd1013288078837680e601"




def analyse_file(file_contents)
  doc = Nokogiri::HTML(file_contents)
  body_el = doc.at_xpath('/html/body')
  if body_el.nil?
    puts "No Body"
    
  else
    extract_xpath(body_el, "html")
  end
  
end

def extract_xpath(node, level)
  attribute_ignore_list = "|style|background|border|cellspacing|width|height|bottommargin|leftmargin|rightmargin|topmargin|onload|onunload|onfocus|onclick|src|alt|title|accesskey|coords|shape|valign|align|"
  element_ignore_list = "|script|br|link|meta|"
  return if element_ignore_list.include? node.name
  this_level = level + "/" + node.name
  node_attributes = "["
  node.attributes.sort.each do |key, value|
    next if attribute_ignore_list.include? "|#{key}|"
    node_attributes += "@#{key}=#{value},"
  end
  node_attributes.chomp!(",")
  node_attributes+= "]"
  this_level += node_attributes unless node_attributes == "[]"
  puts this_level
  $xpath_count += 1
  node.element_children.each {|child_node|
    extract_xpath(child_node, this_level)
  }
        
end

def extract_file(file_name)
  puts "Extracting file at #{file_name}" if $debug
  txt = File.open(file_name)
  file_contents = txt.read()
  txt.close()
  file_contents
end

def build_path(hash_of_file)
  $fileRoot + "/" + hash_of_file[0,2] + "/" + hash_of_file[2,2] + "/" + hash_of_file
end
time = Benchmark.realtime do
  CSV.foreach(csv_file) do |row|
    next unless row[0].to_i > 0
    $file_count += 1
    file_hash = row[1]
    file_name = row[8]
    puts file_hash if $debug
    puts "\n#{file_name}\n--------------------------"
    analyse_file(extract_file(build_path(file_hash)))
  end
end

puts "Time Elapsed: #{time} seconds"
puts "Total html files: #{$file_count}"
puts "Total Paths: #{$xpath_count}"


