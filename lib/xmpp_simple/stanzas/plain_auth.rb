module XMPPSimple
  class PlainAuth < AuthMechanism
    MECHANISM = 'PLAIN'.freeze

    def self.create(jid, password)
      super()
      @node.content = ["#{jid}\x00#{jid.username}\x00#{password}"].pack('m').tr("\n", '')
      @node
    end
  end
end
