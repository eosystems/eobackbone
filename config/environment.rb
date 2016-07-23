# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

class Logger
  class Formatter
    def call(severity, time, progname, msg)
      if msg.class.to_s == 'String'
        msg = msg.gsub(/\n/, '')
        if msg.present? && !((msg.include?('assets') || msg.include?('erb')) && severity == 'ERROR')
          format = "[%s %d] %5s -- %s: \'%s\'\n"
          format % ["#{time.strftime('%Y-%m-%dT%H:%M:%S')}.#{'%06d' % time.usec.to_s}", $PROCESS_ID, severity, progname, msg2str(msg)]
        end
      end
    end
  end
end
