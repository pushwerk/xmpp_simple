module XMPPSimple
  class BaseStanza
    attr_accessor :node

    def self.create
      @node = Node.new(self::NAME)
    end

    def to_xml
      @node.to_xml
    end
  end
end
