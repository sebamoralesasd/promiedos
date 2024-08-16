def report_exception(exception)
  Rails.logger.error(exception.inspect)
  return unless exception.respond_to?(:backtrace) && exception.backtrace.present?

  log_msg = "#{exception.class}: #{exception.message}\n#{exception.backtrace.join("\n")}"

  Rails.logger.error(log_msg)
end
