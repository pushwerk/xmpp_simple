module XMPPSimple
  class PlainAuth < AuthMechanism
    MECHANISM = 'PLAIN'.freeze

    def self.create(jid, password)
      super()
      @node.content = ["\x00#{jid}\x00#{password}"].pack('m').tr("\n", '')
      @node
    end
  end
end
