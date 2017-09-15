require 'ptools'
require 'English'
require_relative 'custom_logger'

# Class FileProcessor - processes a single file
class FileProcessor
  private_class_method def self.process_file_contents(contents, options, output)
    contents.each do |line|
      output << line.encode(options)
    end
  end

  private_class_method def self.process_file_internal(options, path)
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

  def self.process_file(file_name, logger, options, path, regexp)
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
end