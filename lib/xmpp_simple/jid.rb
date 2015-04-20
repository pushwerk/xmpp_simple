module XMPPSimple
  class Jid
    attr_reader :username, :domain

    def initialize(username, host)
      if username.include?('@')
        @username, @domain = username.split('@')
      else
        @username = username
        @domain = host
      end
    end

    def to_s
      "#{@username}@#{@domain}"
    end
  end
end
