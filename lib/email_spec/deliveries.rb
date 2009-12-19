module EmailSpec
  if defined?(Pony)
    #reopen Pony module and replace mail method
    module ::Pony
      def self.deliveries
        @deliveries ||= []
      end

      def self.mail(options)
        deliveries << build_tmail(options)
      end
    end
  end

  module Deliveries
    if defined?(Pony)
      def mailer; Pony; end
    else
      #no mail sender available
      def mailer; raise("email_spec requires Pony"); end
    end

    def all_emails
      mailer.deliveries
    end

    def last_email_sent
      mailer.deliveries.last || raise("No email has been sent!")
    end

    def reset_mailer
      mailer.deliveries.clear
    end

    def mailbox_for(address)
      mailer.deliveries.select { |m| m.to.include?(address) || (m.bcc && m.bcc.include?(address)) || (m.cc && m.cc.include?(address)) }
    end
    include EmailSpec::BackgroundProcesses::Compatibility
  end
end

