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
      @parser = Nokogiri::XML::SAX::PushParser.new self
      @current = nil
      XMPPSimple.logger.error e.message
    end

    def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
      params = { name: name, attrs: attrs, prefix: prefix, uri: uri, ns: ns }
      XMPPSimple.logger.debug "Parse start elem: #{params.inspect}"
      return if name == 'stream'
      doc = @current.nil? ? Nokogiri::XML::Document.new : @current.document
      node = Node.new(name, attrs, ns, doc)
      @current << node if @current
      @current = node
    end

    def end_element_namespace(name, prefix = nil, uri = nil)
      params = { name: name, prefix: prefix, uri: uri }
      XMPPSimple.logger.debug "Parse end elem: #{params.inspect}"
      return if name == 'stream'
      if @current.parent
        @current = @current.parent
        return
      end
      process(@current)
    end

    def characters(chars = '')
      XMPPSimple.logger.debug "Parse chars: #{chars}"
      @current << Nokogiri::XML::Text.new(chars, @current.document) if @current
    end

    def process(node)
      @current = nil
      @client.process(node)
    end
  end
end
