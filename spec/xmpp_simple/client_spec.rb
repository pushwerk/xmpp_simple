RSpec::Matchers.define :same_node do |expected|
  match do |actual|
    actual.to_xml == expected
  end
end

RSpec.describe XMPPSimple::Client do
  before(:each) do
    Celluloid.logger = nil
    @params = {
      username: 'foo@bar.de',
      password: 'password',
      host: 'host',
      port: 5223
    }
  end
  describe '.new' do
    it 'requires username, password, host and port' do
      expect { XMPPSimple::Client.new(handler: TestHandler.new) }
        .to raise_exception('username, password, host and port must be set')
    end

    it 'sets necessary instance variables' do
      handler = TestHandler.new
      params = @params.merge(handler: handler)
      client = XMPPSimple::Client.new(params)
      expect(client.instance_variable_get(:@password)).to match('password')
      expect(client.instance_variable_get(:@username).to_s).to match('foo@bar.de')
      expect(client.instance_variable_get(:@host)).to match('host')
      expect(client.instance_variable_get(:@port)).to eq(5223)
      expect(client.instance_variable_get(:@handler)).to eq(handler)
    end

    it 'converts username to Jid' do
      params = @params.merge(handler: TestHandler.new)
      client = XMPPSimple::Client.new(params)
      expect(client.instance_variable_get(:@username).class).to match(XMPPSimple::Jid)
    end
  end

  context do
    before(:each) do
      @handler = TestHandler.new
      @params = {
        username: 'test@example.com',
        password: 'password',
        host: 'example.com',
        port: 5223,
        handler: @handler
      }
      @socket = TestSocket.new
      @client = XMPPSimple::Client.new(@params)
      @client.instance_variable_set(:@socket, @socket)
    end

    describe '.connect' do
      before(:each) do
        @ssl_socket = TestSocket.new
        allow(Celluloid::IO::TCPSocket).to receive(:new).and_return(@socket)
        allow(Celluloid::IO::SSLSocket).to receive(:new).and_return(@ssl_socket)
        allow_any_instance_of(XMPPSimple::Client).to receive_message_chain(:async, :run).and_return(true)
      end

      it 'creates a new socket' do
        expect(Celluloid::IO::TCPSocket).to receive(:new)
        @client.connect
      end

      it 'converts socket to ssl' do
        expect(Celluloid::IO::SSLSocket).to receive(:new).with(@socket)
        @client.connect
        expect(@client.instance_variable_get(:@socket)).to eq(@ssl_socket)
      end

      it 'starts the xmpp stream' do
        expect_any_instance_of(XMPPSimple::Client).to receive(:start).with(no_args)
        @client.connect
      end

      it 'starts the reader loop ' do
        expect_any_instance_of(XMPPSimple::Client).to receive_message_chain(:async, :run)
        @client.connect
      end

      it 'returns the client and not the socket' do
        expect(@client.connect).to be_a(XMPPSimple::Client)
      end
    end

    describe '.disconnect' do
      it 'sends close stream xml tag' do
        expect_any_instance_of(XMPPSimple::Client).to receive(:write_data).with('</stream>')
        @client.disconnect
      end
    end

    describe '.start' do
      it 'creates a new parser' do
        @client.start
        expect(@client.instance_variable_get(:@parser)).not_to be_nil
      end

      it 'sends open stream xml tag' do
        expect_any_instance_of(XMPPSimple::Client).to receive(:write_data).with(@client.open_stream_xml)
        @client.start
      end
    end

    describe '.reconnect' do
      it 'calls finalize and connect' do
        expect_any_instance_of(XMPPSimple::Client).to receive(:finalize).with(no_args)
        expect_any_instance_of(XMPPSimple::Client).to receive(:connect).with(no_args)
        @client.reconnect
      end
    end

    describe '.process' do
      it 'delegates only valid methods' do
        %w(features success message iq).each do |m|
          node = TestNode.new(m)
          expect_any_instance_of(XMPPSimple::Client).to receive(m.to_sym).with(node)
          @client.process(node)
        end
      end

      it 'ignores other methods' do
        %w(start reconnect disconnect run connect reconnect).each do |m|
          node = TestNode.new(m)
          expect_any_instance_of(XMPPSimple::Client).not_to receive(m.to_sym)
          @client.process(node)
        end
      end

      it 'ignores invalid methods' do
        %w(foo bar test foobar).each do |m|
          node = TestNode.new(m)
          expect { @client.process(node) }.not_to raise_exception
        end
      end
    end

    describe '.write_data' do
      it 'accepts node' do
        xml = XMPPSimple::Message.create
        expect(@socket).to receive(:write).with(xml.to_xml)
        @client.write_data(xml)
      end

      it 'accepts a string' do
        xml = 'foobar'
        expect(@socket).to receive(:write).with(xml)
        @client.write_data(xml)
      end
    end

    describe '.features' do
      it 'sends bind xml' do
        node = Nokogiri::XML('<features><bind xmlns="urn:ietf:params:xml:ns:xmpp-bind"/></features>')
        expect_any_instance_of(XMPPSimple::Client).to receive(:write_data)
          .with(same_node(XMPPSimple::Bind.create.to_xml))
        @client.features(node)
      end

      context 'mechanisms' do
        it 'sends auth on PLAIN' do
          xml = '<features><mechanisms xmlns="urn:ietf:params:xml:ns:xmpp-sasl"> \
          <mechanism>X-OAUTH2</mechanism><mechanism>PLAIN</mechanism></mechanisms></features>'
          features = Nokogiri::XML(xml)
          node = XMPPSimple::PlainAuth.create(XMPPSimple::Jid.new('test@example.com', 'example.com'), 'password')
          expect_any_instance_of(XMPPSimple::Client).to receive(:write_data).with(same_node(node.to_xml))
          @client.features(features)
        end

        it 'disconnects on all other' do
          xml = '<features><mechanisms xmlns="urn:ietf:params:xml:ns:xmpp-sasl"> \
          <mechanism>X-OAUTH2</mechanism><mechanism>OTHER</mechanism></mechanisms></features>'
          node = Nokogiri::XML(xml)
          expect_any_instance_of(XMPPSimple::Client).to receive(:disconnect)
          @client.features(node)
        end
      end

      it 'does nothing on other features' do
        node = Nokogiri::XML('<features><random xmlns="urn:ietf:params:xml:ns:xmpp-bind"/></features>')
        expect_any_instance_of(XMPPSimple::Client).not_to receive(:write_data)
        @client.features(node)
      end
    end

    describe '.success' do
      it 'calls start method' do
        allow_any_instance_of(XMPPSimple::Client).to receive(:start).with(no_args)
        expect_any_instance_of(XMPPSimple::Client).to receive(:start).with(no_args)
        @client.success(nil)
      end
    end

    describe '.message' do
      it 'delegates messages' do
        xml = XMPPSimple::Message.create
        expect(@handler).to receive(:message).with(xml.to_xml)
        @client.message(xml)
      end

      it 'doesn\'t crash when handler doesn\'t implement method' do
        xml = XMPPSimple::Message.create
        params = {
          username: 'test@example.com',
          password: 'password',
          host: 'example.com',
          port: 5223,
          handler: Object.new
        }
        client = XMPPSimple::Client.new(params)
        expect { client.message(xml) }.not_to raise_exception
      end
    end

    describe '.iq' do
      before(:each) do
        @node = TestNode.new('foobar')
      end
      it 'connects on after binding' do
        allow(@node).to receive(:at)
          .with('/iq/bind:bind', 'bind' => 'urn:ietf:params:xml:ns:xmpp-bind')
          .and_return(true)
        expect(@handler).to receive(:connected).with(no_args)
        @client.iq(@node)
      end

      it 'doesn\'t crash when handler doesn\'t implement method' do
        allow(@node).to receive(:at)
          .with('/iq/bind:bind', 'bind' => 'urn:ietf:params:xml:ns:xmpp-bind')
          .and_return(true)
        params = {
          username: 'test@example.com',
          password: 'password',
          host: 'example.com',
          port: 5223,
          handler: Object.new
        }
        client = XMPPSimple::Client.new(params)
        expect { client.iq(@node) }.not_to raise_exception
      end

      it 'does nothing on other iq messages' do
        expect(@handler).not_to receive(:connected)
        @client.iq(@node)
      end
    end

    describe '.run' do
      it 'calls disconnected on socket close' do
        allow(@socket).to receive(:readpartial).with(4096).and_raise(EOFError)
        expect(@handler).to receive(:disconnected).with(no_args)
        @client.run
      end

      it 'doesn\'t crash when handler doesn\'t implement method' do
        socket = TestSocket.new
        params = {
          username: 'test@example.com',
          password: 'password',
          host: 'example.com',
          port: 5223,
          handler: Object.new
        }
        client = XMPPSimple::Client.new(params)
        client.instance_variable_set(:@socket, socket)
        allow(socket).to receive(:readpartial).with(4096).and_raise(EOFError)
        expect { client.run }.not_to raise_exception
      end

      it 'disconnects on other exceptions' do
        allow(@socket).to receive(:readpartial).with(4096).and_raise(RuntimeError)
        expect(@handler).to receive(:disconnected).with(no_args)
        @client.run
      end
    end

    describe '.finalize' do
      context 'not connected' do
        before(:each) do
          @client.instance_variable_set(:@socket, nil)
        end
        it 'doesn\'t write' do
          expect(@client).not_to receive(:write_data)
          expect(@client.instance_variable_get(:@socket)).to be_nil
          @client.finalize
        end
      end
      context 'socket open' do
        it 'closes the socket' do
          expect_any_instance_of(XMPPSimple::Client).to receive(:disconnect).with(no_args)
          expect(@client.instance_variable_get(:@socket)).to receive(:close)
          @client.finalize
        end
      end
    end

    describe '.open_stream_xml' do
      it 'returns the correct xml' do
        expected = <<-EXPECTED
<stream:stream
  xmlns:stream='http://etherx.jabber.org/streams'
  xmlns='jabber:client'
  to='example.com'
  xml:lang='en'
  version='1.0'>
EXPECTED
        expect(@client.open_stream_xml).to match(expected)
      end
    end

    describe '.close_stream_xml' do
      it 'returns the correct xml' do
        expect(@client.close_stream_xml).to match('</stream>')
      end
    end
  end
end
