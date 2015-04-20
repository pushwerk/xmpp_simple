module XMPPSimple
  class Node < Nokogiri::XML::Node
    def self.new(name, attrs = [], ns = [], doc = Nokogiri::XML::Document.new)
      node = super(name, doc)
      attrs.each { |a| node[a.localname] = a.value }
      ns.each { |p, u| node.add_namespace(p, u) }
      node
    end

    def at(*args)
      document.root = self
      document.at(*args)
    end

    def xpath(*args)
      document.root = self
      document.xpath(*args)
    end
  end
end
