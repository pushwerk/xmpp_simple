require 'nokogiri'

module XMPPSimple
  class Parser < Nokogiri::XML::SAX::Document
    def initialize(client)
      @parser = Nokogiri::XML::SAX::PushParser.new self
      @client = client
      @current = nil
    end

    def <<(data)
      @parser << data
      self
    rescue Nokogiri::XML::SyntaxError => e
      XMPPSimple.error e.message
    end

    def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      XMPPSimple.debug "Parse start elem: #{ { name: name, attrs: attrs, prefix: prefix, uri: uri, ns: ns }.inspect }"
      return if name == 'stream'
      doc = @current.nil? ? Nokogiri::XML::Document.new : @current.document
      node = Node.new(name, attrs, ns, doc)
      @current << node if @current
      @current = node
    end

    def end_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      XMPPSimple.debug "Parse end elem: #{ { name: name, attrs: attrs, prefix: prefix, uri: uri, ns: ns }.inspect }"
      return if name == 'stream'
      if @current.parent
        @current = @current.parent
        return
      end
      process(@current)
    end

    def characters(chars = '')
      XMPPSimple.debug "Parse chars: #{chars}"
      @current << Nokogiri::XML::Text.new(chars, @current.document) if @current
    end

    private

    def process(node)
      @current = nil
      @client.process(node)
    end
  end
end
