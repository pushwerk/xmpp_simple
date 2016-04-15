module XMPPSimple
  class Jid
    attr_reader :username, :domain

    def initialize(username, host = nil)
      if username.include?('@')
        @username, @domain = username.split('@')
      else
        raise 'set either host or username@host' if host.nil?
        @username = username
        @domain = host
      end
    end

    def to_s
      "#{@username}@#{@domain}"
    end
  end
end
