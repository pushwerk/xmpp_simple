RSpec.describe XMPPSimple::BaseStanza do
  it 'is creatable' do
    stub_const('XMPPSimple::BaseStanza::NAME', 'foobar')
    expect { @stanza = XMPPSimple::BaseStanza.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    stub_const('XMPPSimple::BaseStanza::NAME', 'foobar')
    @stanza = XMPPSimple::BaseStanza.create
    expect { Nokogiri::XML(@stanza.to_xml) }.not_to raise_exception
    expect(@stanza.to_xml).to match('<foobar/>')
  end
end
