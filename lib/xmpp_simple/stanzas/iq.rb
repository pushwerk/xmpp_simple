module XMPPSimple
  class Iq < BaseStanza
    NAME = 'iq'

    def self.create
      super
      @node['id'] = 'bind_1'
      @node['type'] = 'set'
      @node
    end
  end
end
