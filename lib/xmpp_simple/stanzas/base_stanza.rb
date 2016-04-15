module XMPPSimple
  class BaseStanza
    def self.create
      @node = Node.new(self::NAME)
    end
  end
end
