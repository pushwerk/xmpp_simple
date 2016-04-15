RSpec.describe XMPPSimple::Parser do
  let(:client) { TestClient.new }
  before(:each) do
    @parser = XMPPSimple::Parser.new(client)
  end

  describe '.new' do
    it 'is createable' do
      expect { XMPPSimple::Parser.new(client) }.not_to raise_exception
    end
  end

  describe '<<' do
    it 'delegates data to parser' do
      xml = '<foo></foo>'
      expect(@parser.instance_variable_get(:@parser)).to receive(:<<).with(xml)
      @parser << xml
    end

    it 'detects syntax errors' do
      expect(XMPPSimple).to receive(:error)
      expect { @parser << '<foo></bar>' }.not_to raise_exception
    end

    it 'recovers from syntax errors' do
      @parser << '<foo></bar>'
      expect(XMPPSimple).not_to receive(:error)
      expect { @parser << '<oof></oof>' }.not_to raise_exception
    end

    it 'returns itself' do
      expect(@parser << '<foobar/>').to eq(@parser)
    end
  end

  describe '.start_element_namespace' do
    it 'gets called on element with namespace' do
      expect(@parser).to receive(:start_element_namespace).with('bar', [], 'foo', 'te:st', [['foo', 'te:st']])
      @parser << '<foo:bar xmlns:foo="te:st">'
    end

    it 'gets called on element without namespace' do
      expect(@parser).to receive(:start_element_namespace).with('foobar', [], nil, nil, [])
      @parser << '<foobar>'
    end

    it 'does nothing on open stream' do
      @parser << '<stream>'
      expect(@parser.instance_variable_get(:@current)).to be_nil
    end

    it 'set @current to the opened node' do
      @parser << '<foobar>'
      current = @parser.instance_variable_get(:@current)
      expect(current.name).to match('foobar')
    end

    it 'doesn\'t process any data' do
      expect(@parser).not_to receive(:process)
      @parser << '<foobar>'
    end
  end

  describe 'end_element_namespace' do
    it 'gets called on element with namespace' do
      expect(@parser).to receive(:end_element_namespace).with('bar', 'foo', 'te:st')
      @parser << '<foo:bar xmlns:foo="te:st">'
      @parser << '</foo:bar>'
    end

    it 'gets called on element without namespace' do
      expect(@parser).to receive(:end_element_namespace).with('foobar', nil, nil)
      @parser << '<foobar>'
      @parser << '</foobar>'
    end

    it 'does nothing on close stream' do
      @parser << '<stream>'
      expect(@parser.instance_variable_get(:@current)).to be_nil
      @parser << '</stream>'
    end

    it 'doesn\'t process if not last element' do
      expect(@parser).not_to receive(:process)
      @parser << '<root><foobar>'
      @parser << '</foobar>'
    end

    it 'processes if last element' do
      expect(@parser).to receive(:process) do |node|
        expect(node.name).to match('root')
        expect(node.children.size).to eq(1)
        expect(node.children[0].name).to match('foobar')
      end
      @parser << '<root><foobar>'
      @parser << '</foobar></root>'
    end
  end

  describe 'characters' do
    it 'get called on characters' do
      expect(@parser).to receive(:characters).with('bar')
      @parser << '<root><foo>bar</foo>'
    end

    it 'adds text to node if current is set' do
      @parser << '<root><foo>bar</foo>'
      expect(@parser.instance_variable_get(:@current).text).to match('bar')
    end

    it 'ignores text when current is empty' do
      expect { @parser.characters('bar') }.not_to raise_exception
    end
  end

  describe 'process' do
    it 'resets current' do
      expect(@parser.instance_variable_get(:@current)).to be_nil
      @parser << '<root>'
      expect(@parser.instance_variable_get(:@current)).not_to be_nil
      @parser << '</root>'
      expect(@parser.instance_variable_get(:@current)).to be_nil
    end

    it 'delegates process to client' do
      expect(@parser.instance_variable_get(:@client)).to receive(:process)
      @parser << '<root></root>'
    end
  end
end
