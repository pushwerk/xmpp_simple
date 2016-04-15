module XMPPSimple
  class Bind < Iq
    def self.create
      super()
      bind = Nokogiri::XML::Node.new('bind', @node.document)
      bind.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-bind')
      @node << bind
    end
  end
end
