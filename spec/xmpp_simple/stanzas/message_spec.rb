RSpec.describe XMPPSimple::Message do
  it 'is creatable' do
    expect { @stanza = XMPPSimple::Message.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    @stanza = XMPPSimple::Message.create
    expect { Ox.parse(@stanza.to_xml) }.not_to raise_exception
    expect(@stanza.to_xml).to match('<message/>')
  end
end
