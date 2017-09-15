require 'logger'

# Class CustomLogger - configures logging to stdout and log file
class CustomLogger
  @stdout_logger = nil
  @file_logger = nil

  def initialize(program_name, log_name = nil)
    path = get_path(log_name, program_name)

    puts "Log path: #{path}"

    @stdout_logger = Logger.new(STDOUT)
    log_file = "#{path}\\#{File.basename(program_name)}.log"
    @file_logger = Logger.new(log_file, 'daily')

    @stdout_logger.level = Logger::INFO
    @file_logger.level = Logger::DEBUG
  end

  def log(severity = Logger::INFO, message = nil, prog_name = nil, &block)
    @stdout_logger.add(severity, message, prog_name, &block)
    @file_logger.add(severity, message, prog_name, &block)
  end

  private
  def get_path(log_name, program_name)
    path = File.dirname(program_name).to_s
    dir_name = File.basename(program_name).sub(/\.rb/, '')
    path = "#{ENV['LOG_PATH']}\\#{dir_name}" unless ENV['LOG_PATH'].nil?
    path = log_name unless log_name.nil?
    path
  end
end