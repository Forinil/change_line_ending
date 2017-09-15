#!/usr/bin/env ruby

require 'logger'
require 'ptools'
require 'English'
require_relative 'custom_logger'

def process_file_contents(contents, options, output)
  contents.each do |line|
    output << line.encode(options)
  end
end

def process_file_internal(options, path)
  file = File.open(path, 'r')
  contents = file.readlines
  output = []

  process_file_contents(contents, options, output)

  file.close

  File.open(path, 'wb:utf-8') do |result|
    output.each do |line|
      result.write(line)
    end
  end
end

def process_file(file_name, logger, options, path, regexp)
  logger.log(Logger::DEBUG, "Found file: #{file_name}", 'process_file')
  if File.binary?(path)
    logger.log(Logger::DEBUG, 'File is binary - skipping', 'process_file')
  elsif regexp.match?(file_name)
    process_file_internal(options, path)
  else
    logger.log(Logger::DEBUG,
               "File does not match pattern #{regexp.inspect} - skipping",
               'process_file')
  end
end

def process_files(dir, file_name, logger, options, regexp)
  path = "#{dir}\\#{file_name}"
  logger.log(Logger::DEBUG, "Processing path: #{path}", 'process_files')
  if !File.directory?(path)
    process_file(file_name, logger, options, path, regexp)
  else
    logger.log(Logger::DEBUG, "Found directory: #{file_name}", 'process_files')
    if !file_name.eql?('.') && !file_name.eql?('..')
      process_dir(logger, path, options, regexp)
    end
  end
end

def process_dir(logger, dir = (ENV['TEMP']).to_s,
                options = { universal_newline: true },
                regexp = /.*/)
  logger.log(Logger::INFO, "Opening directory: #{dir}", 'process_dir')
  files = Dir.entries(dir)

  files.each do |file_name|
    process_files(dir, file_name, logger, options, regexp)
  end
end

def set_options(ending, logger)
  options = {}

  options[:universal_newline] = true if ending.eql?('\\n')
  options[:cr_newline] = true if ending.eql?('\\r')
  options[:crlf_newline] = true if ending.eql?('\\r\\n')

  logger.log(Logger::DEBUG, 'Options are:', 'set_options')
  options.each do |key, value|
    logger.log(Logger::DEBUG, "#{key} is #{value}", 'set_options')
  end

  options
end

begin
  logger = nil
  if ARGV.length >= 2
    logger = CustomLogger.new($PROGRAM_NAME, ARGV[3])
    dir = ARGV[0]
    ending = ARGV[1]
    options = set_options(ending, logger)

    if !ARGV[2].nil?
      regexp = Regexp.new(ARGV[2])
      process_dir(logger, dir, options, regexp)
    else
      process_dir(logger, dir, options)
    end
  else
    puts "Usage:\n ./#{File.basename($PROGRAM_NAME)} "\
      'directory_path desired_line_ending included_regexp(optional)'\
      ' log_dir(optional)'
  end
rescue => err
  message = "Error: #{err} from #{$ERROR_POSITION}"
  if logger.nil?
    puts(message)
  else
    logger.log(Logger::FATAL) { message }
  end
end
