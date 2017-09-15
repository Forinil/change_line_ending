require 'English'
require_relative 'custom_logger'
require_relative 'file_processor'

# Class FileProcessor - processes a single directory and its subdirectories
class DirectoryProcessor
  private_class_method def self.process_files(dir, file_name, logger, options, regexp)
    path = "#{dir}\\#{file_name}"
    logger.log(Logger::DEBUG, "Processing path: #{path}", 'process_files')
    if !File.directory?(path)
      FileProcessor.process_file(file_name, logger, options, path, regexp)
    else
      logger.log(Logger::DEBUG, "Found directory: #{file_name}", 'process_files')
      if !file_name.eql?('.') && !file_name.eql?('..')
        process_dir(logger, path, options, regexp)
      end
    end
  end

  def self.process_dir(logger, dir = (ENV['TEMP']).to_s,
                  options = { universal_newline: true },
                  regexp = /.*/)
    logger.log(Logger::INFO, "Opening directory: #{dir}", 'process_dir')
    files = Dir.entries(dir)

    files.each do |file_name|
      process_files(dir, file_name, logger, options, regexp)
    end
  end
end