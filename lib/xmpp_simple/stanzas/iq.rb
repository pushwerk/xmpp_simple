module XMPPSimple
  class Iq < BaseStanza
    NAME = 'iq'.freeze

    def self.create
      super()
      @node['id'] = 'bind_1'
      @node['type'] = 'set'
      @node
    end
  end
end
