module XMPPSimple
  class AuthMechanism < BaseStanza
    NAME = 'auth'.freeze

    def self.create
      super()
      @node.add_namespace(nil, 'urn:ietf:params:xml:ns:xmpp-sasl')
      @node['mechanism'] = self::MECHANISM
      @node
    end
  end
end
