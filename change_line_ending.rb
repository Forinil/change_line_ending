#!/usr/bin/env ruby

require 'English'
require_relative 'custom_logger'
require_relative 'directory_processor'


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
      DirectoryProcessor.process_dir(logger, dir, options, regexp)
    else
      DirectoryProcessor.process_dir(logger, dir, options)
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
